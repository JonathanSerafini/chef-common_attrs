
# A common_secret resource will be used to load a specific secret from a
# common_secrets and apply it to node attributes.
#

resource_name :common_secret

# The period separated path to the target node attribute
property :attribute_path,
  kind_of: String,
  name_attribute: true

# The period seperated path to the source secret
property :secrets_path,
  kind_of: String,
  default: lazy { |r| r.attribute_path }

# The data bag to fetch the secrets from
property :secrets_bag,
  kind_of: String,
  default: lazy { |r| node[:common_attrs][:secrets][:data_bag] }

# The data bag item to fetch the secrets from
property :secrets_item,
  kind_of: String,
  required: true

# Whether to apply this immediately at compile time
property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node[:common_attrs][:secrets][:compile_time] },
  desired_state: false

# Ensure that the resource is applied regardless of whether we are in why_run
# or standard mode.
#
# Refer to chef/chef#4537 for this uncommon syntax
action_class do
  def whyrun_supported?
    true
  end
end

# When compile_time is defined, apply the action immediately and then set the
# action :nothing to ensure that it does not run a second time.
def after_created
  if compile_time
    self.run_action(:apply)
    self.action :nothing
  end
end

action :apply do
  # Ensure that the secret is added to the attribute blacklist to ensure
  # that it is not saved back to the chef server.
  node.default[:common_attrs][:obfuscated][attribute_path] = true

  # Automatically load the data_bag_item to run_state if it has not already
  # been loaded.
  r = common_secrets "#{secrets_bag}.#{secrets_item}" do
    secrets_bag new_resource.secrets_bag
    secrets_item new_resource.secrets_item
    compile_time true
  end

  # To fetch the data from run_state we require the 
  # common_secrets.secret_name
  secrets_name = r.secrets_name
  ecrets_path = new_resource.secrets_path
  secrets = node.run_state[:common_secrets][secrets_name]
  secret = secrets.dig(*secrets_path.split('.'))

  # Set the value as an ObfuscatedType to ensure that the output
  # is never exposed to Chef Server
  secret = Common::Delegator::ObfuscatedType.new(secret)

  unless secret
    raise KeyError.new "secret not found with path #{secrets_path}"
  end

  hash = generate_secret_hash(attribute_path, secret)
  apply_hash(:force_default, hash)
end

# Create a nested hash to use when merging onto node attributes for a secret.
# 
# @param destination [String] a period delimited string refering to an attr
# @param secret [String] the secret to set
# @return [Hash]
# @since 0.1.0
def generate_secret_hash(destination, secret)
  path = destination.split(".")
  last = path.pop

  data = {}
  current = data

  path.each do |item|
    current = current[item] = {}
  end

  current[last] = secret
  data
end

# Apply an attribute hash to the node attributes
#
# @param collection_name [Symbol] name of the node attributes collection
# @param data [Hash] hash to deeply merge into the attribute collection
# @since 0.1.0
def apply_hash(collection_name, data)
  node.attributes.send("#{collection_name}=", DeepMerge.merge(
    node.attributes.send(collection_name),
    data
  ))
end

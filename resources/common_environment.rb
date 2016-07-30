# A common_environment resource is used to provide the environment databag
# pattern which is used with Policy Files to replicate the concept of a global
# configuration space.
#
# This will load an (protentially encrypted) data_bag_item and then apply it 
# at the desired precedence level.
#
# @since 0.1.0
# @example
# ```json
# {
#   "id": "name",
#   "default_attributes": {},
#   "override_attributes": {}
# }
# ```

resource_name :common_environment

# The data_bag_item name to load
property :environment,
  kind_of: String,
  name_attribute: true

# The data_bag to fetch the environment from
property :data_bag,
  kind_of: String,
  default: lazy { node['common_attrs']['environments']['data_bag'] }

# The level of precendence to apply attributes at
property :precedence,
  kind_of: String,
  equal_to: ["environment","role","node"],
  default: "environment"

# Whether to apply the resource at compile time
property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node['common_attrs']['environments']['compile_time'] }

# Whether we should ignore missing items or raise an error
property :ignore_missing,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node['common_attrs']['environments']['ignore_missing'] }

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
    self.action(:nothing)
  end
end

# Apply a data_bag environment file to node attributes
#
action :apply do
  item_data = fetch_item(data_bag, environment)

  item_data.keys.each do |item_precedence|
    item_data[item_precedence].keys.each do |key|
      Chef::Log.debug("#{self} applying #{item_precedence} to node.#{key}")
    end
  end

  case precedence
  when "environment"
    apply_hash(:env_default, item_data.fetch(:default_attributes, {}))
    apply_hash(:env_override, item_data.fetch(:override_attributes, {}))
  when "role"
    apply_hash(:role_default, item_data.fetch(:default_attributes, {}))
    apply_hash(:role_override, item_data.fetch(:override_attributes, {}))
  when "node"
    apply_hash(:default, item_data.fetch(:default_attributes, {}))
  else raise ArgumentError.new "invalid scope defined: #{scope}"
  end
end

# Include Chef DSL providing search methods
#
include Chef::DSL::DataQuery

# Fetch a databag item to include into the node attributes
#
# @param data_bag [String]
# @param item [String]
# @return [Hash]
# @since 0.1.0
def fetch_item(data_bag, item)
  data = data_bag_item(data_bag, item)
  data.to_common_data
rescue Net::HTTPServerException => e
  Chef::Log.warn "#{self} could not find the environment named #{name}"
  if ignore_missing then {}
  else raise
  end
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

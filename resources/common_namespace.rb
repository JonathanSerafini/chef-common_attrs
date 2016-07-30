# A common_namespace resource is used to overlay attributes found within a
# given namespace to the root level attributes.
#
# @since 0.1.0
# @example
# ```json
# {
#   "_production": {
#     "value": "production"
#   },
#   "_development": {
#     "value": "development
#   },
#   "value": "unset"
# }
# ```

resource_name :common_namespace

# The namespace attribut path to lookup
property :namespace,
  kind_of: String,
  name_attribute: true

# The destination attribute path to lookup and apply the namespace to
property :destination,
  kind_of: String,
  default: nil

# The level of precendence to apply attributes at
property :precedence,
  kind_of: String,
  default: 'environment'

# An optional prefix to prepend to the namespace name
property :prefix,
  kind_of: [String, NilClass],
  default: lazy { node['common_attrs']['namespaces']['prefix'] }

# Whether to apply the namespact at compile or converge time
property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node['common_attrs']['namespaces']['compile_time'] }

def after_created
  if compile_time
    self.run_action(:apply)
    self.action :nothing
  end
end

# Ensure that the resource is applied regardless of whether we are in why_run
# or standard mode.
#
# Refer to chef/chef#4537 for this uncommon syntax
action_class do
  def whyrun_supported?
    true
  end
end

action :apply do
  apply_hash(fetch_attribute("#{prefix}#{namespace}", {}))
end

# Lookup an attribute by array or comma delimited list
#
# @since 0.1.2
# @returns [Node::Attribute] the node attribute
def fetch_attribute(path, default = nil)
  node.dig(*path.split('.')) || default
end

# Apply an attribute hash to the node attributes
#
# @param hash [Hash] hash containing attributes
# @since 0.1.0
def apply_hash(hash)
  destination = destination.nil? ? node : fetch_attribute(destination, nil)
  destination = destination.attributes if destination.is_a?(Chef::Node)
  raise ArgumentError.new 'node attribute not found' if destination.nil?

  hash.keys.each do |key|
    Chef::Log.debug("#{self} applying namespace to node.#{key}")
  end

  case precedence
  when 'environment'
    destination.env_default = DeepMerge.merge(destination.env_default, hash)
  when 'role'
    destination.role_default = DeepMerge.merge(destination.role_default, hash)
  when 'node'
    destination.default = DeepMerge.merge(destination.default, hash)
  else raise ArgumentError.new "Invalid scope defined: #{scope}"
  end
end

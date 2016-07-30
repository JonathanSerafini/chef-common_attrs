
default['common_attrs']['namespaces'].tap do |config|
  # Name of the namespaces to apply first
  # @since 0.1.0
  config['active']['prepend'] = begin
    data = []
    data << "env_#{node.environment.sub(/^_/,'')}"
    data << "env_#{node.policy_group}"    if node.respond_to?(:policy_group) &&
                                             node.policy_group
    data << "policy_#{node.policy_name}"  if node.respond_to?(:policy_name) &&
                                             node.policy_name
    data
  end.compact.uniq

  # Name of the namespaces to apply second
  # @since 0.1.0
  config['active']['custom'] = []

  # Optional namespace name prefix
  # @since 0.1.0
  config['prefix'] = "_"

  # Whether to apply namespaces at compile-time or converge-time
  # @since 0.1.0
  config['compile_time'] = true
end


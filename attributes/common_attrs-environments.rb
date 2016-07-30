
default['common_attrs']['environments'].tap do |config|
  # Name of the data_bag to search when loading additional node attributes
  # @since 0.1.0
  config['data_bag'] = 'environments'

  # Name of the data_bag_items to load first
  # @since 0.1.0
  config['active']['prepend'] = begin
    data = []
    data << "env_#{node.environment.sub(/^_/, '')}"
    data << "env_#{node.policy_group}"    if node.respond_to?(:policy_group) &&
                                             node.policy_group
    data << "policy_#{node.policy_name}"  if node.respond_to?(:policy_name) &&
                                             node.policy_name
    data
  end.compact.uniq

  # Name of the data_bag_items to load second
  # @since 0.1.0
  config['active']['custom'] = []

  # Whether to apply environments at compile-time or converge-time
  # @since 0.1.0
  config['compile_time'] = true

  # Whether to ignore missing items or raise an exception
  # @since 0.1.0
  config['ignore_missing'] = false
end


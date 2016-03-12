
default[:common_attrs][:environments].tap do |config|
  # Name of the data_bag to search when loading additional node attributes
  # @since 0.1.0
  config[:data_bag] = "environments"

  # Name of the data_bag_items to load first
  # @since 0.1.0
  config[:active][:prepend] = [
    node.environment,
    node.policy_group,
    node.policy_name
  ].compact.uniq

  # Name of the data_bag_items to load second
  # @since 0.1.0
  config[:active][:custom] = []

  # Whether to apply environments at compile-time or converge-time
  # @since 0.1.0
  config[:compile_time] = true

  # Whether to ignore missing items or raise an exception
  # @since 0.1.0
  config[:ignore_missing] = false
end


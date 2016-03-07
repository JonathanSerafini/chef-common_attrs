
default[:common_attrs][:namespaces].tap do |config|
  # Name of the data_bag_items to prepend to active
  config[:active][:prepend] = [
    node.environment,
    node.policy_group,
    node.policy_name
  ].compact.uniq

  # Name of the data_bag_items to attempt to load
  config[:active][:custom] = []

  # Optional namespace name prefix
  config[:prefix] = "_"

  # Whether to apply namespaces at compile-time or converge-time
  config[:compile_time] = true
end


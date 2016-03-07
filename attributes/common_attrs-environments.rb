
default[:common_attrs][:environments].tap do |config|
  # Name of the data_bag to search when loading additional node attributes
  config[:data_bag] = "environments"

  # Name of the data_bag_items to prepend to active
  config[:active][:prepend] = [
    node.environment,
    node.policy_group,
    node.policy_name
  ].compact.uniq

  # Name of the data_bag_items to attempt to load
  config[:active][:custom] = []

  # Whether to apply environments at compile-time or converge-time
  config[:compile_time] = true

  # Whether to ignore missing items or raise an exception
  config[:ignore_missing] = false
end


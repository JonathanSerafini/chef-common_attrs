
default[:common_attrs][:namespaces].tap do |config|
  # Name of the namespaces to apply first
  # @since 0.1.0
  config[:active][:prepend] = [
    node.environment,
    node.policy_group,
    node.policy_name
  ].compact.uniq

  # Name of the namespaces to apply second
  # @since 0.1.0
  config[:active][:custom] = []

  # Optional namespace name prefix
  # @since 0.1.0
  config[:prefix] = "_"

  # Whether to apply namespaces at compile-time or converge-time
  # @since 0.1.0
  config[:compile_time] = true
end



default['common_attrs']['secrets'].tap do |config|
  # Name of the data_bag to search when loading additional node attributes
  # @since 0.1.0
  config['data_bag'] = "secrets"

  # Whether to apply secrets at compile-time or converge-time
  # @since 0.1.0
  config['compile_time'] = true

  # Hash of secrets to lookup and apply
  # - hash key will be a period separated path to the attribute
  # - hash value is a hash of common_secret properties
  # @since 0.1.0
  # @example 
  # ```json
  # node.default['common_attrs']['secrets']["my_app.my_secret"] = {
  #   data_bag_item: "my_app"
  # }
  # ```
  config['active'] = {}
end


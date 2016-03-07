
default[:common_attrs][:secrets].tap do |config|
  # Name of the data_bag to search when loading additional node attributes
  config[:data_bag] = "secrets"

  # Whether to apply environments at compile-time or converge-time
  config[:compile_time] = true

  # Hash of secrets to lookup and apply
  # @example 
  # ```json
  # node.default[:common_attrs][:secrets]["my_app.my_secret"] = {
  #   data_bag_item: "my_app"
  # }
  # ```
  config[:active] = {}
end


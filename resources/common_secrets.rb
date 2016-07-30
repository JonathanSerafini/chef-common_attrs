
# A common_secrets resource will be used to load a secrets data_bag_item and
# save to to node.run_state. If the secrets have already been loaded, then this
# resource will have no effect.
#

resource_name :common_secrets

# The data bag item to fetch the secrets from
property :secrets_item,
  kind_of: String,
  required: true

# The data bag to fetch the secrets from
property :secrets_bag,
  kind_of: String,
  default: lazy { node['common_attrs']['secrets']['data_bag'] }

# The unique identifier for this secrets container which is used to store the
# values in the run_state
property :secrets_name,
  kind_of: String,
  default: lazy { |r| "#{r.secrets_bag}.#{r.secrets_item}" }

# Whether to apply this immediately at compile time
property :compile_time,
  kind_of: [TrueClass, FalseClass],
  default: lazy { node['common_attrs']['secrets']['compile_time'] },
  desired_state: false

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
    self.action :nothing
  end
end

# Include Chef DSL methods to load data_bag_items
include Chef::DSL::DataQuery

action :apply do
  run_state = node.run_state

  if run_state['common_secrets'] && run_state['common_secrets'][secrets_name]
    @new_resource.updated_by_last_action(false)
  else
    data = data_bag_item(new_resource.secrets_bag, new_resource.secrets_item)
    data = data.to_common_namespace
    node.run_state['common_secrets'] ||= {}
    node.run_state['common_secrets'][secrets_name] = data
  end
end


Chef.event_handler do
  # On converge_complete, when we no longer need to actual values of attributes
  # for runtime, we will iterate through the list attributes we wish to
  # delete them.
  #
  # @since 0.1.5
  on :converge_complete do
    node = Chef.run_context.node

    node[:common_attrs][:blacklisted].each do |key, value|
      # Skip unless enabled
      next if value === false

      # Skip if attribute is not found
      next unless node.dig *key.split('.')

      # Because logging
      Chef::Log.debug "Blacklisting attribute #{key}"

      # Delete attribute, otherwise it doesnt work
      node.rm *key.split('.')
    end
  end
end


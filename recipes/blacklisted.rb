
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
      
      attribute_path = key.split('.')

      # Skip if attribute is not found
      next unless node.dig *attribute_path

      # Because logging
      Chef::Log.debug "Blacklisting attribute #{key}"

      # Delete attribute
      node.rm *attribute_path
      attribute_path.pop

      # Delete any empty nestings
      while attribute_path.any? do
        attribute_value = node.dig *attribute_path
        break unless attribute_value.empty?

        node.rm *attribute_path
        attribute_path.pop
      end
    end
  end
end


Chef.event_handler do
  # On converge_complete, when we no longer need to actual values of attributes
  # for runtime, we will iterate through the list attributes we wish to
  # obfuscate and overwrite them.
  #
  # Ideally we would of had just ObfuscatedType.to_json sitting within the 
  # attribute tree however Chef uses Yajl which doesn't call the method. 
  #
  # /sadpanda
  # @since 0.1.2
  on :converge_complete do
    node = Chef.run_context.node

    node['common_attrs']['obfuscated'].each do |key, value|
      # Skip unless enabled
      next if value === false

      # Skip if attribute is not found
      next unless node.dig *key.split('.')

      # Because logging
      Chef::Log.debug "Obfuscating attribute #{key}"

      # Delete attribute, otherwise it doesnt work
      node.rm *key.split('.')

      # Assign value
      node.default.common_assign_at(
        *key.split('.'), 
        "**suppressed sensitive output**"
      )
    end
  end
end

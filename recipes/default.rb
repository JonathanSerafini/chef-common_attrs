
include_recipe "#{cookbook_name}::environments"
include_recipe "#{cookbook_name}::namespaces"
include_recipe "#{cookbook_name}::secrets"
include_recipe "#{cookbook_name}::obfuscated"
include_recipe "#{cookbook_name}::blacklisted"


# common_attrs cookbook

A cookbook which provides tools (libraries, custom resources) to help manage Attributes during Chef runs. This is especially useful when using PolicyFiles which require a workflow to replace the concept of Environments.

*Be advised* that this cookbook provides you with all of the necessary tools to shoot yourself in the foot ... repeatedly ... so much so that you may end up a bloody mess. When making use of any of the Custon Resources contained within, you should be sure to have a workflow in mind. 

# Requirements

This cookbook required *Chef 12.7.0* or later.

# Platform

Any

# Documentation

Comments will be found throughout the attribute, resource and library files
so that the documentation and code are more closely linked. What's found in 
this Readme will be more of a high-level overview.

# Custom Resources

### common_environment

Resource which will load a `data_bag_item` and apply it's contents onto the `node` at either the `environment` or `role` precedence levels during compile time. The format of this file should be mostly identical to existing `environment` files, with only the *default_attributes* and *override_attributes* keys being honored.

A recipe, `common_attrs::environments`, also exists which will iterate through config[:common_attrs][:environments][:active][:prepend] and create a `common_environment` for each of : node.environment, node.policy_group, node.policy_name. 

The recipe will then loop through config[:common_attrs][:environments][:active][:custom], creating whatever further `common_environment` resources are required. 
### common_namespae

Resource which will take a Hash-ish node attribute and merge it onto the `node` at the `environment` precedence level. This allows you to set attribute overrides for a given environment, policy_group or policy_file in a centralize location.

A recipe, `common_attrs::namespaces`, also exists which will iterate through config[:common_attrs][:namespaces][:active][:prepend] and create a `common_namespace` for each of : node.namespace, node.policy_group, node.policy_name. 

The recipe will then loop through config[:common_attrs][:namespaces][:active][:custom], creating whatever further `common_namespace` resources are required. 

### common_secrets

Resource which will load a `data_bag_item` containing secrets into the `node.run_state` if it has not already been created. This may then be used by other resources, such as `common_secret` or directly within your recipes.

### common_secret

Resource which will load a secret from `common_secret` and apply it's value to a `node` attribute at compile time. In addition, the attribute path will be registered to `node[:common_attrs][:obfuscated]` so that it's value is wiped prior to reporting to Chef server.

# Recipes

- default: Load allofthethings
- environments: Load `common_environment` from attributes
- namespaces: Load `common_namespace` from attributes
- secrets: Load `common_secret` from attributes
- obfuscated: Register a Chef Event handler to obfuscate attributes at the end of the converge phase.

# Library Methods

This cookbook provides a number of helper methods and injects a few of them by monkey patching DataBagItem, Node::Atributes and Resource. When doing this, special care is taken to ensure that the method names are namespaced so as to minimize future WTF moments.

Documentation on each of these may be found within the library files.

- Hash.dig
- Hash.common_assign_at
- Resource.common_properties
- DataBagItem.to_common_data
- DataBagItem.to_common_namespace
- EncryptedDataBagItem.to_common_data
- EncryptedDataBagItem.to_common_namespace
- Attribute.to_common_data
- Attribute.to_common_namespace
- Comon::Delegator::ObfuscatedType

# Attribute Precedence

Given that we're dealing with Attributes, special care needs to be taken to ensure that we don't get lost in the myriad of different precedence levels.

|new?|source|precedence level|
|---|---|---|
|no|cookbook.attribute|default|
|no|cookbook.recipe|default|
|no|environment|environment_default|
|yes|common_environment|environment_default|
|yes|common_namespace|environment_default|
|no|role|role_default|
|no|policy_file|role_default|
|yes|common_secrets|force_default|
|no|cookbook.attribute|normal|
|no|cookbook.recipe|normal|


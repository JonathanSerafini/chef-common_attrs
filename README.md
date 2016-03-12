# common_attrs cookbook
 
A cookbook which provides Custom Resources to help manage Attributes. This may
be used in a standard deployment where you use Environments as well as, and 
mostly for, deployments that rely on PolicyFiles. 

Specifically, this cookbook will provide the following Custom Resources :
* *common_environment*: Load a data_bag_item and apply it to the node at the `env_default` and `env_override` precedence levels.
* *common_namespace*: Overlay a given attribute onto the root of the node object at either the `env_default` precedence level.
* *common_secrets*: Load a data_bag_item and save it under `node.run_state` to be used for further purposes.
* *common_secret*: Load a `common_secrets` if required, and copy one of it's attributes onto the node at the `force_default` precedence level. Additionally, ensure that the value will not be sent to your Chef Server.

*Be advised* that this cookbook provides you with all of the necessary tools to shoot yourself in the foot ... repeatedly ... so much so that you may end up a bloody mess. When making use of any of the Custon Resources contained within, you should be sure to have a workflow in mind. 

# Requirements

This cookbook required *Chef 12.7.0* or later.

# Platform

Any

# Documentation

Commons will be found throughout the attribute, resource and library files
so that the documentation and code are more closely linked. What's found in 
this Readme will be more of a high-level overview.

## Library Methods

This cookbook provides a number of helper methods and injects a few of them
by monkey patching DataBagItem, Node::Atributes and Resource. Documentation
on each of these may be found within the library files.

- Hash.dig
- Hash.dig=
- Resource.common_properties
- DataBagItem.to_common_data
- DataBagItem.to_common_namespace
- Attribute.to_common_Data
- Attribute.to_common_namespace
- Comon::Delegator::ObfuscatedType

## Attribute Precedence

Given that we're dealing with Attributes, special care needs to be taken to ensure that we don't get lost in the myriad of different precedence levels.

|new?|source|precedence level|
|---|---|---|
|no|cookbook.attribute|default|
|no|cookbook.recipe|default|
|no|environment|environment_default|
|yes|common_environment|environment_default|
|yes|common_namespace|environment_default|
|no|role|role_default|
|no|role|policy_file default|
|yes|common_secrets|force_default|
|no|cookbook.attribute|normal|
|no|cookbook.recipe|normal|


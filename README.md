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

Comments may be found in both the attribute files as well as the specific Custom Resources and will provide most of the documentation.

## Attribute Precedence

Given that we're dealing with Attributes, special care needs to be taken to ensure that we don't get lost in the myriad of different precedence levels.

- cookbook Attribute default
- cookbook Recipe default
- *optional* Environment default
- *added* common_environment default
- *added* common_namespace default
- *optional* Role default
- *optional* PolicyFile default
- *optional* cookbook Attribute force_default
- *optional* cookbook Recipe force_default
- *added* common_secrets force_default
- cookbook Attribute normal
- cookbook Recipe normal
- *optional* override, force_override

## Custom Resources

*TODO* :D


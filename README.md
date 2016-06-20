# common_attrs cookbook

A cookbook which provides tools (libraries, custom resources) to help manage Attributes during Chef runs. This is especially useful when using PolicyFiles which require a workflow to replace the concept of Environments.

**Be advised** that this cookbook provides you with all of the necessary tools to shoot yourself in the foot ... repeatedly. When making use of any of the Custom Resources contained within, you should be sure to have a workflow in mind.

# Requirements

* Chef **12.7.0** or later.

# Platform

Any

# Custom Resources

### common_environment

A custom resource which is designed to replicate the concept of *Environment* objects in deployments that make use of *PolicyFiles*.

During compile time, these resources will load a *data_bag_item* and then apply it's contents to the *node* attributes at a configurable (or auto detected) precedence level.

#### Attributes

###### common_attrs.environments.data_bag

The *data_bag* from which to fetch environment items which are formatted much like one would a standard *environment* file.

```json
{
  "id": "production",
  "default_attributes": {
    "key": "value"
  },
  "override_attributes": {
    "key": "value"
  }
}
```

###### common_attrs.environments.compile_time

A boolean value which provides a default value for the *common_environment* resource and which determines whether the resources should be applied during compile or converge phase.

###### common_attrs.environments.ignore_missing

A boolean value which provides a default value for the *common_environment* resource and which determines whether the resources should throw an exception when a data_bag_item is not found.

###### common_attrs.environments.active.prepend

An array of data_bag_item names which is used by the *common_attrs::environments* recipe to create *common_environment* resources.

By default, this array will contain the following entries :
* env_#{node.environment.sub(/^\_/,'')} : the current environment or 'default'
* env_#{node.policy_group} : the policy_group name if defined
* env_#{node.policy_name} : the policy_name if defined

###### common_attrs.environments.active.custom

An array of data_bag_item names which is used by the *common_attrs::environments* recipe to create *common_environment* resources.

By default, this array is left empty and is provided to allow you to extend without overriding the auto-generated values in *prepend*.

#### Recipe

###### common_attrs::environments

This recipe will automatically create *common_environment* resources based on the values found in attributes, first for *prepend* and then for *custom*.

#### Resources

###### common_environment

Actions
* apply: Apply the environment to the node

Properties
* environment: (name attribute) The name of the data_bag_item to load.
* data_bag: The data_bag to load from. This defaults to *node.common_attrs.environments.data_bag*.
* precedence: The precedence level to apply to, which may be either environment, role or node.
* compile_time: Whether to apply the environment during compile or converge time.
* ignore_missing: Whether to throw an exception if the data_bag_item is missing.

### common_namespace

A custom resource which provides an alternative to the *Environment* pattern where one would provide configurations specific to a given environment within an attribute namespace.

As an example, the following node attributes provided by cookbooks, PolicyFiles, Environments, Roles or *common_environment*:

```json
{
  "application": {
    "database_host": "127.0.0.1",
    "database_port": 3306,
    "num_processes": 1
  },
  "_production": {
    "application": {
      "database_host": "db.myapp.domain.com",
      "num_processes": 50  
    }
  },
  "_staging": {
    "application": {
      "database_host": "db.myapp.domain.test",
      "num_processes": 10  
    }
  }
}
```

#### Attributes

###### common_attrs.namespaces.compile_time

A boolean value which provides a default value for the *common_namespace* resource and which determines whether the resources should be applied during compile or converge phase.

###### common_attrs.namespaces.prefix

A string with which to prefix namespace names when attempting to locate node attributes. The initial idea is that this be a simple character (_ by default), however this could be a word followed by a period which would expand to an entire hash key.

###### common_attrs.namespaces.active.prepend

An array of namespace names which is used by the *common_attrs::namespace* recipe to create *namespace* resources.

By default, this array will contain the following entries :
* env_#{node.environment.sub(/^\_/,'')} : the current environment or 'default'
* env_#{node.policy_group} : the policy_group name if defined
* env_#{node.policy_name} : the policy_name if defined

###### common_attrs.namespaces.active.custom

An array of namespace names which is used by the *common_attrs::namespace* recipe to create *namespace* resources.

By default, this array is left empty and is provided to allow you to extend without overriding the auto-generated values in *prepend*.

#### Recipe

###### common_attrs::namespaces

This recipe will automatically create *common_namespace* resources based on the values found in attributes, first for prepend and then for custom.

#### Recipe

###### common_attrs::environments

This recipe will automatically create *common_environment* resources based on the values found in attributes, first for *prepend* and then for *custom*.

#### Resources

###### common_namespace

Actions
* apply: Apply the namespace to the node

Properties
* namespace: (name attribute) The name of the namespace to apply.
* destination: A period separated path to the attribute to apply this namespace to, defaulting to the root level of the node.
* precedence: The precedence level to apply to, which may be either environment, role or node.
* prefix: The prefix to apply to the namespace name and which defaults to *common_attrs.namespaces.prefix*
* compile_time: Whether to apply the namespace during compile or converge time.

### common_secrets

Custom resources which will load a *data_bag_item* containing secrets into the *node.run_state* if it has not already been created. This may then be used by other resources, such as *common_secret* or directly within your recipes.

Example:
```json
{
  "id": "secrets",
  "my_key": "my_value"
}
```

```ruby
common_secrets "secrets"
raise node.run_state[:common_secrets][:secrets][:my_key]
```

```json
{
  "common_secrets":{
    "active":{
      "deploy_keys": {
        "attribute_path": "common_auth.users.config.www-data.keys.private_keys.deploy",
        "secrets_item": "deploy"
      }
    }
  }
}
```

#### Attributes

###### common_attrs.secrets.data_bag

The *data_bag* from which to fetch secrets items. The format of the *data_bag_item* is free form.

###### common_attrs.secrets.compile_time

A boolean value which provides a default value for the *common_secrets* resource and which determines whether the resources should be applied during compile or converge phase.

###### common_attrs.secrets.active

A hash of key => hash pairs which are used by the recipes to create instances of common_secrets and where the name refers to the common_secrets name and the hash is any properties to apply.

```json
{
  "action": {
    "secrets": {
      "compile_time": true,
      "secrets_item": "data_bag_item_name"
    }
  }
}
```

#### Recipes

###### common_attrs:secrets

This recipe will automatically create *common_secret* resources based on the values found in attributes.

#### Resources

###### common_secrets

Actions
* apply: Apply the secrets to the node run_state

Properties
* secrets_item: (name attribute) The name of the data_bag_item to load.
* secrets_bag: The name of the data_bag to load items from.
* secrets_name: The name of the key under node.run_state[:common_secrets] to load this in.
* compile_time: Whether to apply the secrets during compile or converge time.

###### common_secret

Actions
* apply: Apply the secret to node attributes

Properties
* attribute_path: (name attribute) The location where to copy the secret to.
* secrets_path: The path within the *common_secret* run_state hash where the secret may be found.
* secrets_item: The name of the data_bag_item to load.
* secrets_bag: The name of the data_bag to load items from.
* compile_time: Whether to apply the secret during compile or converge time.

# Additional Recipes / Attributes

### Attributes Obfuscated

Hash of key => boolean values where the keys represent a path to an attribute that should be replaced prior to Chef reporting to chef server.

#### Attributes

###### common_attrs.obfuscated

```json
{
  "plain": {
    "text": {
      "secret": "value"
    }
  },
  "common_attrs": {
     "obfuscated": {
      "plain.text.secret": true
    }
  }
}
```

#### Recipes

###### common_attrs::obfuscated

This recipe creates a *converge_complete* event handler which will go through the hash of obfuscated types and replace their content with `**suppressed sensitive output**`.

### Attributes Blacklisted

Hash of key => boolean values where the keys represent a path to an attribute that should be deleted prior to Chef reporting to chef server.

#### Attributes

###### common_attrs.blacklisted

```json
{
  "plain": {
    "text": {
      "secret": "value"
    }
  },
  "common_attrs": {
     "blacklisted": {
      "plain.text.secret": true
    }
  }
}
```

#### Recipes

###### common_attrs::blacklisted

This recipe creates a *converge_complete* event handler which will go through the hash of obfuscated types and deletes their content.

# Library Methods

This cookbook provides a number of helper methods and injects a few of them by monkey patching DataBagItem, Node::Attributes and Resource. When doing this, special care is taken to ensure that the method names are namespaced so as to minimize future WTF moments.

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
- Common::Delegator::ObfuscatedType

# Attribute Precedence

Given that we're dealing with Attributes, special care needs to be taken to ensure that we don't get lost in the myriad of different precedence levels.

The table below contains a listing of where the new custom resources fit within this precedence from least important to most.

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

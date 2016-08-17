common_attrs
======

v0.4.4
------
* Bugfix
  * to\_common\_namespace did not correctly detect namespace attributes

v0.4.3
------
* Bugfix
  * Better detect when policy is enabled

v0.4.2
------
* Bugfix
  * New namespace/environment loaders were not setting attributes correctly

v0.4.1
------
* Enhancement
  * Prefix autodetection ends up being overly complicated, revert that.

v0.4.0
------
* Enhancement
  * Prefix environment, policy_group, policy_name with a word which enables
    autodetection of precedence levels. On one hand, it makes that easier, on
    the other it helps make the data_bag item list more readable.

* Bugfix
  * Fixed an issue where the attributes would throw an exception when the node
    did not support policies

v0.3.0
------
* Enhancement
  * Allow common_environment to apply to node.default
  * Allow common_namespace to apply to node.default

v0.2.0
------
* Enhancement
  * Provide support for loading entire hashes from common_secret instead of
    only allowing single keys.

v0.1.5
------
* Add attribute blacklisting
* Add whyrun support/bypass to all common_attr resources

v0.1.4
------
* Add EncryptedDataBagItem monkey patches


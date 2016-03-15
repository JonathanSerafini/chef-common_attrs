# Monkey patch Chef::EncryptedDataBagItem by including additional modules
#
require_relative 'common-mixin-chefish_hash'
require_relative 'common-mixin-namespaced_hash'
require_relative 'common-mixin-diggable_hash'

Chef::EncryptedDataBagItem.send(:include, Common::Mixin::ChefishHash)
Chef::EncryptedDataBagItem.send(:include, Common::Mixin::NamespacedHash)
Chef::EncryptedDataBagItem.send(:include, Common::Mixin::DiggableHash)

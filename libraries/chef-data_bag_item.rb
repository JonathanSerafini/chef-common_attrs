# Monkey patch Chef::DataBagItem by including additional modules
#
require_relative 'common-mixin-chefish_hash'
require_relative 'common-mixin-namespaced_hash'
require_relative 'common-mixin-diggable_hash'

Chef::DataBagItem.send(:include, Common::Mixin::ChefishHash)
Chef::DataBagItem.send(:include, Common::Mixin::NamespacedHash)
Chef::DataBagItem.send(:include, Common::Mixin::DiggableHash)

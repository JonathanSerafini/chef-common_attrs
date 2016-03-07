require_relative 'common-mixin-chefish_hash'
require_relative 'common-mixin-namespaced_hash'
require_relative 'common-mixin-diggable_hash'

Chef::Node::Attribute.send(:include, Common::Mixin::ChefishHash)
Chef::Node::Attribute.send(:include, Common::Mixin::NamespacedHash)

unless Hash.new.respond_to?(:dig)
  Chef::Node::Attribute.send(:include, Common::Mixin::DiggableHash)
end

# Monkey patch Hash by including additional modules
#
require_relative 'common-mixin-diggable_hash'

Hash.send(:include, Common::Mixin::DiggableHash)

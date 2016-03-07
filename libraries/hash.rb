require_relative 'common-mixin-diggable_hash'

unless Hash.new.respond_to?(:dig)
  Hash.send(:include, Common::Mixin::DiggableHash)
end

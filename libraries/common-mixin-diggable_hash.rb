module Common
  module Mixin
    module DiggableHash
      module DigLookup
        # Provide a mechanism to lookup a deeply nested hash key by providing
        # it with an array of keys. Should any of the keys not be present, 
        # `nil` will be return.
        #
        # This is effectively backporting the method from Ruby 2.3
        # 
        # @param *path [String,Symbol] * keys describing the path
        # @return [Mix, Nil]
        # @since 0.1.0
        def dig(*path)
          path.inject(self) do |location, key|
            location.respond_to?(:keys) ? location[key] : nil
          end
        end
      end

      # Optionally include the DigLookup module only if it was not previously
      # defined so as to not overwrite Ruby 2.3's method if it is available.
      def self.included(base)
        base.instance_eval do
          unless respond_to?(:dig)
            send(:include, Common::Mixin::DiggableHash::DigLookup)
          end
        end
      end

      # Provide a mechanism to set the value of a deeply nested hash key
      # by providing it with an array of keys and a value. 
      #
      # This will return an exception if the parent object was not found or 
      # is not a Hash.
      #
      # @param *path [String,Symbol] * keys describing the path
      # @param value [Mix] the last provided argument is the value to set
      # @since 0.1.0
      def dig=(*path, value)
        last_item = path.pop
        dig(*path)[last_item] = value
      end
    end
  end
end

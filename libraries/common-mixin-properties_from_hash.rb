module Common
  module Mixin
    module PropertiesFromHash
      # Provides a method to load resource properties from a Hash type object,
      # such as a DataBagItem or Node::Attribute, while also ensuring that we
      # will be friendly a skip any unsupported properties.
      #
      # @param hash [Hash] the properties to set
      # @since 0.1.0
      def common_properties(hash)
        hash = {} if hash.nil?

        data = if hash.respond_to?(:to_common_data)
               then hash.to_common_data
               else hash.to_h
               end 

        data.each do |key, value|
          if respond_to?(key.to_sym)
            Chef::Log.debug "#{self} setting #{key} from hash"
            send(key.to_sym, value)
          else
            Chef::Log.warn "#{self} received unhandled property #{key}"
          end
        end
      end
    end
  end
end

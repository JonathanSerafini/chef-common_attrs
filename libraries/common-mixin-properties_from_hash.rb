module Common
  module Mixin
    module PropertiesFromHash
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

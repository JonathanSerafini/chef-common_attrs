require_relative 'common-mixin-obfuscated_type'

module Common
  module Delegator
    class ObfuscatedType < SimpleDelegator
      include Common::Mixin::ObfuscatedType

			def class
			  __getobj__.class
      end

      def is_a?(*args)
        __getobj__.is_a?(*args)
      end

      def kind_of?(*args)
        __getobj__.kind_of?(*args)
      end
    end
  end
end

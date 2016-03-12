require_relative 'common-mixin-obfuscated_type'

module Common
  module Delegator
    # A simple delegator which will ensure that we can provide any wrapped 
    # object with methods from Common::Mixin::ObfuscatedType.
    # 
    # The delegator will be used to wrap around objects that we set in either
    # node attributes or resource properties in order to ensure that the
    # objects are neither printed out to logs or sent to chef server.
    #
    # Unfortunately, I haven't found a non-EVIL way of doing this, so I'm
    # being an asshole and replacing `class`, `is_a?` and `kind_of?` to make
    # sure that that the objects will be used transparently by Chef. Without 
    # some of these EVIL hacks, we'd fail property type checking.
    #
    # @example
    # > my_resource.property = Common::Delegator::ObfuscatedType("secret")
    # > my_resource.property.is_a?(String)
    # # true
    # > my_resource.property.to_text
    # # *** suppressed output ***
    #
    # @since 0.1.0
    class ObfuscatedType < SimpleDelegator
      # Include the Obfuscation methods
      # @since 0.1.0
      include Common::Mixin::ObfuscatedType

      # ObfuscatedType.new("string").class == String
      # @since 0.1.0
			def class
			  __getobj__.class
      end

      # ObfuscatedType.new("string").is_a?(String)
      # @since 0.1.0
      def is_a?(*args)
        __getobj__.is_a?(*args)
      end

      # ObfuscatedType.new("string").kind_of?(String)
      # @since 0.1.0
      def kind_of?(*args)
        __getobj__.kind_of?(*args)
      end
    end
  end
end

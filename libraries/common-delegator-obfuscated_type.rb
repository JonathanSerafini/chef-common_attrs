require_relative 'common-mixin-obfuscated_type'

module Common
  module Delegator
    class ObfuscatedType < SimpleDelegator
      include Common::Mixin::ObfuscatedType

      def initialize(value)
        super(value)
      end
    end
  end
end

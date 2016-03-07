module Common
  module Mixin
    module ObfuscatedType
      def to_text
        "**suppressed sensitive output**"
      end

      def to_json(*args)
        to_text.to_json(*args)
      end
    end
  end
end

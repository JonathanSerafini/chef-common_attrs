module Common
  module Mixin
    module ObfuscatedType
      # Provide a method to ensure that the object will not print to the either
      # stdout or to the log files.
      #
      # The to_text method is used by Chef internally when determining how to
      # print certain objects to screen or logs. For instance, this is used
      # when a Resource experiences an Exception.
      #
      # @return [String] the obfuscated string
      # @since 0.1.0
      def to_text
        "**suppressed sensitive output**"
      end

      # Provide a method to ensure that the object will not be exported to 
      # Chef server during the final report. 
      #
      # @return [Json] the obfuscated string in Json format
      # @since 0.1.0
      def to_json(*args)
        to_text.to_json(*args)
      end
    end
  end
end

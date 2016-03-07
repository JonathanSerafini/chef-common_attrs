module Common
  module Mixin
    module DiggableHash
      # Fetch deeply nested Hash items or return nil
      # *Note*: This has been implemented in Ruby 2.3
      def dig(*path)
        path.inject(self) do |location, key|
          location.respond_to?(:keys) ? location[key] : nil
        end
      end

      def dig=(*path, value)
        last_item = path.pop
        dig(*path)[last_item] = value
      end
    end
  end
end

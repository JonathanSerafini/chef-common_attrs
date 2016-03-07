module Common
  module Mixin
    module ChefishHash
      def to_common_data
        data = Mash.new(to_hash)

        data.delete_if do |key,_|
          %w(id chef_type data_bag).include?(key)
        end

        data
      end
    end
  end
end


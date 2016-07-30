module Common
  module Mixin
    module ChefishHash
      # Chef Hashish objects provide a to_hash method. Some of these, like
      # DataBagItem, return metadata fields that are not strictly data which
      # will be stripped by this method.
      # @return [Mash]
      # @since 0.1.0
      def to_common_data
        data = Mash.new(to_hash)

        data.delete_if do |key, _|
          %w(id chef_type data_bag).include?(key)
        end

        data
      end
    end
  end
end

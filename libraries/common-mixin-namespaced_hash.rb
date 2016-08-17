module Common
  module Mixin
    module NamespacedHash
      # Return this object as a Hash, with all namespaces applied to the top
      # level.
      #
      # @param *namespaces [String,Symbol] an arbitrary amount of namespaces
      # @return [Mash]
      # @since 0.1.0
      def to_common_namespace(*namespaces)
        attributes = Chef.run_context.node['common_attrs']['namespaces']
        prefix = attributes['prefix']

        # Convenience to ensure we're using namespaces even if unset
        if Array(namespaces).empty?
          namespaces = [
            attributes['active']['prepend'],
            attributes['active']['custom']
          ].flatten.compact.uniq
        end

        # Clean namespaces and enforce prefix
        namespaces.map! do |namespace|
          namespace = namespace.to_s
          namespace = "#{prefix}#{namespace}" unless namespace =~ /^#{prefix}/
          namespace
        end

        # Apply namespaces to data
        # - Optionally support our custom to_data method for cleanliness
        data = if self.respond_to?(:to_common_data)
               then self.to_common_data
               else self.to_h
               end

        namespaces.each do |namespace|
          attr_hash = data.fetch(namespace, {})
          data = Chef::Mixin::DeepMerge.merge(data, attr_hash)
        end

        # Return
        data
      end
    end
  end
end

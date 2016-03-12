# Monkey patch Chef::Resource by including additional modules
#
require_relative 'common-mixin-properties_from_hash'

Chef::Resource.send(:include, Common::Mixin::PropertiesFromHash)

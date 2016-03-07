
node[:common_attrs][:namespaces][:active][:prepend].each do |namespace|
  common_namespace namespace do
    action :apply
  end
end

node[:common_attrs][:namespaces][:active][:custom].each do |namespace|
  common_namespace namespace do
    action :apply
  end
end


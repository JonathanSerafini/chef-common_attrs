node['common_attrs']['environments']['active']['prepend'].each do |environment|
  common_environment environment do
    action :apply
  end
end

node['common_attrs']['environments']['active']['custom'].each do |environment|
  common_environment environment do
    action :apply
  end
end

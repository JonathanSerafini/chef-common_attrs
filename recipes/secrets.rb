node['common_attrs']['secrets']['active'].each do |key, hash|
  common_secret key do
    common_properties(hash)
  end
end

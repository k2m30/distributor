json.array!(@sites) do |site|
  json.extract! site, :name, :regexp
  json.url site_url(site, format: :json)
end

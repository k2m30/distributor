json.array!(@urls) do |url|
  json.extract! url, :url, :price
  json.url url_url(url, format: :json)
end

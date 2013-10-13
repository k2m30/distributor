json.array!(@logs) do |log|
  json.extract! log, :message, :price_found, :name_found, :type, :ok, :ok_all
  json.url log_url(log, format: :json)
end

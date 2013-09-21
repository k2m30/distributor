json.array!(@settings) do |setting|
  json.extract! setting, :ban_time, :last_updated, :allowed_error, :update_time
  json.url setting_url(setting, format: :json)
end

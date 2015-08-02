json.array!(@managers) do |manager|
  json.extract! manager, :id, :date_of_birth
  json.url manager_url(manager, format: :json)
end

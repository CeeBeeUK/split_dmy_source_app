json.array!(@posts) do |post|
  json.extract! post, :id, :posted
  json.url post_url(post, format: :json)
end

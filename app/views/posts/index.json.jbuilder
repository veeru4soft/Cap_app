json.array!(@posts) do |post|
  json.extract! post, :id, :post_name, :post_description
  json.url post_url(post, format: :json)
end

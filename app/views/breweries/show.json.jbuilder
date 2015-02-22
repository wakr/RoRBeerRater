json.extract! @brewery, :id, :name, :year, :created_at, :updated_at

json.beerCount do
  json.amount @brewery.beers.count
end

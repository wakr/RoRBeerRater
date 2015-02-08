class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
  end

  def self.bar_in_place(bar)
    Rails.cache.fetch(bar, expires_in: 1.week) { fetch_place_with(bar) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"
    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]
    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_place_with(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get "#{url}"
    place = response.parsed_response['bmp_locations']['location']

  end

  def self.key
    "c30e83aef4a5d5443868a60a907df535"
   # raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    #ENV['APIKEY']
  end
end
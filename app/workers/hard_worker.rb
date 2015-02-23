class HardWorker
  include Sidekiq::Worker

  def asd
    while true do
      sleep 5.minutes
      Rails.cache.write("beer top 3", Beer.top(3), expires_in: 5.minutes)
      Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 5.minutes)
      Rails.cache.write("style top 3", Style.top(3), expires_in: 5.minutes)
      Rails.cache.write("user top 3", User.top(3), expires_in: 5.minutes)
      Rails.cache.write("recent ratings", Rating.recent, expires_in: 5.minutes)
    end
  end

  def perform(name, count)
    puts 'Doing hard work'
  end

end
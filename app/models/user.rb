class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 , maximum: 15}
  validates :password, length: {minimum: 4}
  validates_format_of :password, :with => /(?=.*\d)(?=.*([A-Z]))/

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    styles = beers.all.map(&:style)
    fs = styles.max_by {|s| calculate_average_for_s s}
    fs
  end

  def favorite_brewery
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer.brewery
    brews = beers.all.map(&:brewery)
    fb = brews.max_by {|b| calculate_average_for_b b}
    fb

  end

  def calculate_average_for_s style
    ratings_with_style = ratings.to_a.select {|r| r.beer.style == style}
    rating_scores = ratings_with_style.to_a.map(&:score)
    sumOfAll = rating_scores.sum
    average = sumOfAll / rating_scores.count
    average
  end


    def calculate_average_for_b brewery
      ratings_with_brewery = ratings.to_a.select {|r| r.beer.brewery.name == brewery.name}
      rating_scores = ratings_with_brewery.to_a.map(&:score)
      sumOfAll = rating_scores.sum
      average = sumOfAll / rating_scores.count
      average
    end

end

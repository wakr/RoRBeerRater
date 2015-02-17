class User < ActiveRecord::Base
  include RatingAverage, Rounder

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 , maximum: 15}
  validates :password, length: {minimum: 4}
  validates_format_of :password, :with => /(?=.*\d)(?=.*([A-Z]))/

  scope :active, -> {where banned:[nil,false]}
  scope :banned, -> {where banned:true}


  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy


  def self.top(n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def rated_breweries
    ratings.map{ |r| r.beer.brewery }.uniq
  end

  def rated_styles
    ratings.map{ |r| r.beer.style }.uniq
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def rating_of_brewery(brewery)
    ratings_of_brewery = ratings.select do |r|
      r.beer.brewery == brewery
    end
    ratings_of_brewery.map(&:score).sum / ratings_of_brewery.count
  end

  def rating_of_style(style)
    ratings_of_style = ratings.select do |r|
      r.beer.style == style
    end
    ratings_of_style.map(&:score).sum / ratings_of_style.count
  end
  

end

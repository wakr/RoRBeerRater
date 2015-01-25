class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 , maximum: 15}

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships

end

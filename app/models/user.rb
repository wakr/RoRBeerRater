class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3 , maximum: 15}
  validates :password, length: {minimum: 3}
  validates_format_of :password, :with => /[A-Z\d]+/

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy

end

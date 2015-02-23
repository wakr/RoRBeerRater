class Beer < ActiveRecord::Base
  include RatingAverage, Rounder

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> {uniq}, through: :ratings, source: :user
  belongs_to :style, touch: true


  def to_s
    "#{self.name}" + " | #{self.brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
  end

end

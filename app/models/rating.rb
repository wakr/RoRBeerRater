class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user, touch: true

  include Rounder

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :recent, -> {order(:created_at).reverse.first(5)}

  def to_s
    "#{self.beer.name}" + " | #{self.score}"
  end

end

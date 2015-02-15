class Brewery < ActiveRecord::Base
  include RatingAverage, Rounder

  validates :name, presence: true, :allow_nil => false
  validates :year, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_cannot_be_more_than_yearnow

  scope :active, -> {where active:true}
  scope :retired, -> {where active:[nil,false]}

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_cannot_be_more_than_yearnow
    if year
      if year > Time.now.year
        errors.add(:year, "can't be in the future")
      end
    end
  end

  def print_report
    puts self.name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2015
    puts "changed year to #{year}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
  end


end

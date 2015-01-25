class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true, :allow_nil => false
  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_cannot_be_more_than_yearnow

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_cannot_be_more_than_yearnow
    if year > Time.now.year
      errors.add(:year, "can't be in the future")
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


end

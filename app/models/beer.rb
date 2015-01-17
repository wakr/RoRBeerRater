class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating

    ratingScores = ratings.to_a.map(&:score)
    sum = ratingScores.inject{ |s,x| s + x }
    average = sum / ratings.count.to_f
    "#{average}"

  end

  def to_s
    "#{self.name}" + " | #{self.brewery.name}"
  end

end

module RatingAverage
  extend ActiveSupport::Concern


  def average_rating

    ratingScores = self.ratings.to_a.map(&:score)
    sum = ratingScores.inject{ |s,x| s + x }
    if self.ratings.count > 0
    average = sum / self.ratings.count.to_f
    average
    else
      0
    end

    end
end
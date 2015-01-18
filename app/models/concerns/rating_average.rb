module RatingAverage
  extend ActiveSupport::Concern


  def average_rating

    ratingScores = self.ratings.to_a.map(&:score)
    sum = ratingScores.inject{ |s,x| s + x }
    average = sum / self.ratings.count.to_f
    average

    end
end
class Style < ActiveRecord::Base
  has_many :beers, dependent: :destroy

  include Rounder

  def to_s
    self.name
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
    # palauta listalta parhaat n kappaletta
  end

  def average_rating
      averages = []
      beers_with_same_style = Beer.all.to_a.select {|b| b.style.name == self.name}
      beers_with_same_style.each do |b|
        averages << b.average_rating.to_i
      end
    sum = averages.inject{|sum,x| sum + x }
      if beers_with_same_style.count > 0
    average = sum / beers_with_same_style.count
    average
      else
        0
      end

end

end


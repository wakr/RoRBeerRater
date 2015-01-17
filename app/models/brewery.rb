class Brewery < ActiveRecord::Base
  has_many :beers

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

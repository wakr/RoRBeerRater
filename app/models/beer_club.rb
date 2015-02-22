class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships


  def unconfirmed_applications
    self.memberships.find_by confirmed:false
  end


end

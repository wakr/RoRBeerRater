class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :beer_club_id, presence: true, :allow_nil => false

  scope :confirmed, -> {where confirmed:true}
  scope :unconfirmed, -> {where confirmed:false}
end

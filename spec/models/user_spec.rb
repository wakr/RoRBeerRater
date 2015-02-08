require 'rails_helper'

RSpec.describe User, :type => :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){FactoryGirl.create(:user)}

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved when password is too short" do
    user = User.create username:"Pekka", password:"S1", password_confirmation:"S1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved when password contains only letters" do
    user = User.create username:"Pekka", password:"SAAMi", password_confirmation:"SAAMi"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      beer = FactoryGirl.create(:beer)

      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end

  end

  describe "favorite style" do

    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      beer = FactoryGirl.create(:beer)
      expect(user.favorite_style).to eq(nil)
    end

    it "with one rating has one" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "with multiple ratings has the most common" do

      style1 = Style.create name: "Porter", description:"..."
      style2 = Style.create name: "Lager", description:"..."

      beer1 = Beer.create name: "1", style:style1
      beer2 = Beer.create name: "2", style:style2
      beer3 = Beer.create name: "3", style:style1
      beer4 = Beer.create name: "4", style:style1

      # pitäisi tulla lager

      rating = FactoryGirl.create(:rating, beer:beer1, user:user) #10
      rating2 = FactoryGirl.create(:rating3, beer:beer2, user:user) #17
      rating3 = FactoryGirl.create(:rating4, beer:beer3, user:user)  #30
      rating4 = FactoryGirl.create(:rating, beer:beer4, user:user) #10


      expect(user.favorite_style.name).to eq(beer2.style.name)
    end

  end

  describe "favorite brewery" do

    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      beer = FactoryGirl.create(:beer)
      expect(user.favorite_brewery).to eq(nil)
    end

    it "with one rating has one" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "with multiple ratings has the most common" do
      # 1) laske keskiarvo 2) ota kaikki keskiarvon yli 3) ota suurin esiintyvyys
      brewery = FactoryGirl.create :brewery
      brewery2 = Brewery.create name: "test", year: 2000
      style1 = Style.create name: "Porter", description:"..."
      style2 = Style.create name: "Lager", description:"..."

      beer1 = Beer.create name: "1", style:style1, brewery_id: brewery.id
      beer2 = Beer.create name: "2", style:style2, brewery_id: brewery2.id
      beer3 = Beer.create name: "3", style:style1, brewery_id: brewery.id
      beer4 = Beer.create name: "4", style:style1, brewery_id: brewery.id



      # pitäisi tullla lager

      rating = FactoryGirl.create(:rating, beer:beer1, user:user) #10
      rating2 = FactoryGirl.create(:rating3, beer:beer2, user:user) #17
      rating3 = FactoryGirl.create(:rating4, beer:beer3, user:user)  #30
      rating4 = FactoryGirl.create(:rating, beer:beer4, user:user) #10


      expect(user.favorite_brewery).to eq(beer2.brewery)


    end

  end


end


def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end


def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
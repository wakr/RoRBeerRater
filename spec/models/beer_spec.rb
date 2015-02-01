require 'rails_helper'

RSpec.describe Beer, :type => :model do
  it "can be added when has name and style" do
    beer = Beer.create name:"TestBeer", style:"Lager"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "can't be created without a name" do
    beer = Beer.create style:"Lager"
    expect(beer).not_to be_valid
  end

  it "can't be created without a style" do
    beer = Beer.create name:"TestBeer"
    expect(beer).not_to be_valid
  end

  describe "when one beer exists" do
    let(:beer){FactoryGirl.create(:beer)}

    it "is valid" do
      expect(beer).to be_valid
    end

    it "has the default style" do
      expect(beer.style).to eq("Lager")
    end
  end

end


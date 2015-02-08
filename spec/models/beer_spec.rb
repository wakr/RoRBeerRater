require 'rails_helper'

RSpec.describe Beer, :type => :model do

  it "can be added when has name and style" do
    style_ = Style.create name: "teststyle", description: "..."
    beer = Beer.create name:"TestBeer", style:style_
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "can't be created without a name" do
    style_ = Style.create name: "teststyle", description: "..."
    beer = Beer.create style:style_
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
      expect(beer.style.name).to eq("Lager")
    end
  end

end


require 'rails_helper'

describe "Beers page" do

  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }
  let!(:style) { FactoryGirl.create :style }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "adds a beer when it has a name" do
    visit new_beer_path
    fill_in('beer_name', with:'test')
    click_button('Create Beer')
    expect(page).to have_content 'Beer was successfully created.'
  end

  it "gives an error if beer is invalid" do
    visit new_beer_path
    click_button('Create Beer')
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end

end
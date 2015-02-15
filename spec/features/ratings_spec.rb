require 'rails_helper'
include OwnTestHelper

describe "Ratings page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "shows the amount of ratings correctly when no ratings" do
    visit ratings_path

    expect(page).to have_content "Number of ratings: 0"
  end

  it "shows the amount of ratings correctly when there are rating" do
    Rating.create score: 10, beer_id:1
    visit ratings_path
    expect(page).to have_content "Number of ratings: 1"
  end

  it "shows favorite brewery and style correctly" do
    FactoryGirl.create :rating, beer_id:beer1.id, user_id: user.id
    visit user_path(user)
    expect(page).to have_content beer1.style
    expect(page).to have_content beer1.brewery.name
  end

  it "no favorite brewery if no ratings" do
    visit user_path(user)
    expect(page).to have_content "No favorite style because has no ratings done yet."
    expect(page).to have_content "No favorite brewery because has no ratings done yet."
  end

end
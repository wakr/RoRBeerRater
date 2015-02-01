require 'rails_helper'

include OwnTestHelper

describe "Users page" do
  before :each do

  end

  let!(:user2) {FactoryGirl.create :user2 }
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }


  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when no ratings done, shows no ratings done" do
      sign_in(username:"Pekka", password:"Foobar1")
      FactoryGirl.create :rating3, beer_id:beer1.id, user_id: 1
      visit user_path(user)
      expect(page).to have_content "No ratings yet!"
    end

    it "when has ratings shows only ratings done by self" do
      sign_in(username:"Kaapo", password:"Asd1")
      FactoryGirl.create :rating, beer_id:beer1.id, user_id: user2.id
      FactoryGirl.create :rating, beer_id:beer2.id, user_id: user2.id
      FactoryGirl.create :rating2, beer_id:beer1.id, user_id: 2
      FactoryGirl.create :rating2, beer_id:beer1.id, user_id: 2
      visit user_path(user2)
      expect(page).to have_content "Has made 2 ratings ratings, average 10.0"
    end

    it "when removing own ratings, it is also removed from the database" do
      sign_in(username:"Kaapo", password:"Asd1")
      FactoryGirl.create :rating, beer_id:beer1.id, user_id: user2.id
      FactoryGirl.create :rating, beer_id:beer2.id, user_id: user2.id
      FactoryGirl.create :rating2, beer_id:beer1.id, user_id: 2
      FactoryGirl.create :rating2, beer_id:beer1.id, user_id: 2
      visit user_path(user2)

      expect{
        page.first(:link, "delete").click
      }.to change{Rating.count}.from(Rating.count).to(Rating.count-1)

    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
end
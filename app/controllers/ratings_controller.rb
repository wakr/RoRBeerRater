class RatingsController < ApplicationController

  def background_worker
      Rails.cache.write("beer top 3", Beer.top(3), expires_in: 5.minutes)
      Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 5.minutes)
      Rails.cache.write("style top 3", Style.top(3), expires_in: 5.minutes)
      Rails.cache.write("user top 3", User.top(3), expires_in: 5.minutes)
      Rails.cache.write("recent ratings", Rating.recent, expires_in: 5.minutes)
  end

  def is_cached name
    Rails.cache.exist? name
  end



  def index

    # Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }

    @ratings =  Rating.includes(:beer, :user).all
    @top_breweries = nil
    @top_beers = nil
    @top_styles = nil
    @top_raters = nil
    @recent_ratings = nil

    if is_cached("beer top 3")
      @top_beers = Rails.cache.read "beer top 3"
    else
      @top_beers = Beer.top(3)
    end

    if is_cached("brewery top 3")
      @top_breweries = Rails.cache.read "brewery top 3"
    else
      @top_breweries = Brewery.top(3)
    end

    if is_cached("style top 3")
      @top_styles = Rails.cache.read "style top 3"
    else
      @top_style = Style.top(3)
    end

    if is_cached("user top 3")
      @top_raters = Rails.cache.read "user top 3"
    else
      @top_raters = User.top(3)
    end

    if is_cached("recent ratings")
      @recent_ratings = Rails.cache.read "recent ratings"
    else
      @recent_ratings = Rating.recent
    end

    #byebug

    background_worker
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end
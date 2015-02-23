class RatingsController < ApplicationController

  #before_action :skip_if_cached, only:[:index]

  def skip_if_cached
    return render :index if fragment_exist?( "toplists"  )
  end

  def update_cache
    Rails.cache.write("beer top 3", Beer.top(3), expires_in: 5.minutes) unless is_cached "beer top 3"
    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 5.minutes) unless is_cached "brewery top 3"
    Rails.cache.write("style top 3", Style.top(3), expires_in: 5.minutes) unless is_cached "style top 3"
    Rails.cache.write("user top 3", User.top(3), expires_in: 5.minutes) unless is_cached "user top 3"
    Rails.cache.write("recent ratings", Rating.recent, expires_in: 5.minutes) unless is_cached "recent ratings"
  end


  def is_cached name
    Rails.cache.exist? name
  end



  def index

    update_cache

    @top_beers = Rails.cache.read "beer top 3"
    @top_breweries = Rails.cache.read "brewery top 3"
    @top_styles = Rails.cache.read "style top 3"
    @top_raters = Rails.cache.read "user top 3"
    @recent_ratings = Rails.cache.read "recent ratings"
    @ratings = Rating.includes(:user, :beer).all


  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    expire_fragment("toplists")
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
    expire_fragment("toplists")
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end

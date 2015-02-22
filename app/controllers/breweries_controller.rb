class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :skip_if_cached, only:[:index]

  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "brewerylist-#{@order}"  )
  end

  # GET /breweries
  # GET /breweries.json
  def index
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    @breweries = Brewery.all


    @active_breweries = case @order
                          when 'name' then @active_breweries.sort_by{ |b| b.name }
                          when 'year' then @active_breweries.sort_by { |b| b.year}
                        end

    @retired_breweries = case @order
                           when 'name' then @retired_breweries.sort_by{ |b| b.name }
                           when 'year' then @retired_breweries.sort_by { |b| b.year}
                         end

    if session[:last_order] == @order and not session[:reversed]

      @active_breweries = case @order
                            when 'name' then @active_breweries.sort_by{ |b| b.name }.reverse
                            when 'year' then @active_breweries.sort_by { |b| b.year}.reverse
                          end

      @retired_breweries = case @order
                             when 'name' then @retired_breweries.sort_by{ |b| b.name }.reverse
                             when 'year' then @retired_breweries.sort_by { |b| b.year}.reverse
                           end
      session[:reversed] = true
    else
      session[:reversed] = false
    end
    session[:last_order] = @order

  end

  def list

  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    ["brewerylist-name", "brewerylist-year"].each{ |f| expire_fragment(f) }
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end


end

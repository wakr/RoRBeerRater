
  class SessionsController < ApplicationController
    def new
      # renderöi kirjautumissivun
    end

    def create_oauth
        byebug
    end

    def create
      user = User.find_by username: params[:username]



      if User.banned.include? user
        redirect_to :back, notice: "Account with a username #{user.username} is banned. Please contact admins."
      elsif user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to :back, notice: "Username and/or password mismatch"
      end
    end

    def destroy
      # nollataan sessio
      session[:user_id] = nil
      # uudelleenohjataan sovellus pääsivulle
      redirect_to :root
    end
  end

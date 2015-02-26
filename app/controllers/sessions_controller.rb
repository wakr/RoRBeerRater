
  class SessionsController < ApplicationController

    require "securerandom"

    include SecureRandom

    def new
      # renderöi kirjautumissivun
    end

    def create_oauth

          new_user = User.new username: env["omniauth.auth"].info.nickname

          if User.all.find_by(username: new_user.username).nil?
            secure_token = env["omniauth.auth"].uid + giveSecureToken
            new_user = User.create username: env["omniauth.auth"].info.nickname, password: secure_token, password_confirmation: secure_token
            session[:user_id] =  new_user.id
            redirect_to user_path(new_user), notice: "Welcome to the system!"
          else
            new_user = User.all.find_by username: new_user.username
            session[:user_id] =  new_user.id
            redirect_to user_path(new_user), notice: "Welcome back!"
          end






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

    private

    def giveSecureToken
      SecureRandom.urlsafe_base64(2) + (0...2).map { ('A'..'Z').to_a[rand(26)] }.join
    end

  end

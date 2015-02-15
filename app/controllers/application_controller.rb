class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif current_user.admin.nil?
      redirect_to signin_path, notice:'you should be admin'
    else
    redirect_to signin_path, notice:'you should be admin' if not current_user.admin
    end
  end

end

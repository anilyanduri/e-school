class LoginController < ApplicationController
  before_action :store_location, only: [:login]

  def new
    if Current.user.nil?
      @user = User.new
      render( template: 'registration/new' )
    else
      redirect_to '/'
    end
  end

  def login
    user = User.find_by(email: params[:user][:email].downcase)
    if user.present? && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect_back_or("/")
    else
      flash.now[:danger] = 'Invalid email/password combination!'
      @user = User.new
      render( template: 'registration/new' )
    end
  end

  def logout
    session[:user_id] = nil
    Current.user = nil
    session.clear
    redirect_to root_path, flash: {light: 'Successfully Logged out'}
  end
end

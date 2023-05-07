class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_current_user

  def set_current_user
    Current.user = User.find_by_id(session[:user_id]) if session[:user_id]
  end


end

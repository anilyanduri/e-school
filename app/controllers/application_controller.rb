class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_current_user, :set_current_school


end

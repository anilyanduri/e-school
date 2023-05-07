module SessionsHelper

  # def current_user
  #   Current.user
  # end

  def logged_in?
    !Current.user.nil?
  end

  def log_out
    session.delete(:user_id)
    Current.user = nil
  end

  def current_user?(user)
    user == Current.user
  end

  def redirect_back_or(default, options)
    forwarding_url = session[:forwarding_url]
    session.delete(:forwarding_url)
    redirect_to(forwarding_url || default, options)
  end

  def store_location
    session[:forwarding_url] = request.env["HTTP_REFERER"]
  end

end
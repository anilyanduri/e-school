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
    session.clear
  end

  def set_current_user
    Current.user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def set_current_school
    Current.school = Current.user&.schools&.first
  end

  def current_user?(user)
    user == Current.user
  end

  def redirect_back_or(default, options={})
    forwarding_url = session[:forwarding_url]
    session.delete(:forwarding_url)
    redirect_to(forwarding_url || default, options)
  end

  def store_location
    session[:forwarding_url] = request.env["HTTP_REFERER"]
  end

  def require_admin_or_school_admin_privilege!
    if ! (Current.user.has_role?(ADMIN) || Current.user.has_role?(SCHOOL_ADMIN, (@school || Current.school) ) )
      Rails.logger.info "[require_admin_privilege] User dont have Admin role."
      store_location
      respond_to do |format|
        flash.now[:dander] = "<h1>Unauthorized !<h1>".html_safe
        format.html { render html: "<h1>Unauthorized !<h1>".html_safe, layout: true, status: 401 }
        format.json { render json: {status: 401}, status: 401 }
      end
    end
  end

  def require_admin_privilege!
    unless Current.user.has_role?(ADMIN)
      Rails.logger.info "[require_admin_privilege] User dont have Admin role."
      store_location
      respond_to do |format|
        flash.now[:dander] = "<h1>Unauthorized !<h1>".html_safe
        format.html { render html: "<h1>Unauthorized !<h1>".html_safe, layout: true, status: 401 }
        format.json { render json: {status: 401}, status: 401 }
      end
    end
  end

end
class RegistrationController < ApplicationController

  def new
    if Current.user.nil?
      @user = User.new
      @schools = School.active.all.collect {|s| [s.name, s.id] }
    else
      redirect_to root_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if school = School.find(params[:school_id])
        @user.add_role :student, school
      end
      session[:user_id] = @user.id
      flash[:light] = 'Successfully created account'
      redirect_to root_path
    else
      flash.now[:warning] = @user.errors.collect {|e| e.options[:message]  }.join('<br />')
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name)
    end
end

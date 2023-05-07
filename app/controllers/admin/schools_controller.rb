module Admin
  class SchoolsController < ApplicationController
    before_action :set_school, only: %i[ show edit update destroy toogle_status toogle_school_admin]
    before_action :require_admin_privilege!

    # GET /schools or /schools.json
    def index
      @schools = School.all
    end

    # GET /schools/1 or /schools/1.json
    def show
      @users = []
      @users << @school.school_admins
      @users << @school.students
      @users.flatten!.uniq!
    end

    # GET /schools/new
    def new
      @school = School.new
    end

    # GET /schools/1/edit
    def edit
    end

    # POST /schools or /schools.json
    def create
      @school = School.new(school_params)
      @school.created_by = Current.user
      @school.status = NEW

      respond_to do |format|
        if @school.save
          flash.now[:success] = "School was successfully created."
          format.html { redirect_to admin_school_url(@school) }
          format.json { render :show, status: :created, location: @school }
        else
          flash.now[:danger] = @school.errors.collect {|e| e.options[:message]  }.join('<br />')
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @school.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /schools/1 or /schools/1.json
    def update
      respond_to do |format|
        if @school.update(school_params)
          flash.now[:success] = "School was successfully updated."
          format.html { redirect_to admin_school_url(@school)}
          format.json { render :show, status: :ok, location: @school }
        else
          flash.now[:danger] = @school.errors.collect {|e| e.options[:message]  }.join('<br />')
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @school.errors, status: :unprocessable_entity }
        end
      end
    end

    def toogle_status
      respond_to do |format|
        @school.toogle_status
        if @school.save
          flash.now[:success] = "#{@school.active? ? 'Activated' : 'De Activated' } #{@school.name}"
          format.js
          format.json { render :show, status: :ok, location: @school }
        else
          format.js
          format.json { render json: @school.errors, status: :unprocessable_entity }
        end
      end
    end

    def toogle_school_admin
      respond_to do |format|
        @user = User.find(params[:user_id])
        role_added = false
        if @user.has_role?(:school_admin, @school)
          @user.remove_role :school_admin, @school
          role_added = false
        else
          @user.add_role(:school_admin, @school)
          role_added = true
        end
        if @user.errors.blank?
          flash.now[:success] = "#{role_added ? 'updated' : 'removed' } #{@user.fullname} as Admin"
          format.js
          format.json { render :show, status: :ok, location: @school }
        else
          format.js
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /schools/1 or /schools/1.json
    def destroy
      @school.destroy

      respond_to do |format|
        flash[:success] = "School was successfully removed."
        format.html { redirect_to admin_schools_path}
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :description, :status, :user_id)
    end
  end

end

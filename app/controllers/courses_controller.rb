class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy study]
  before_action :require_admin_or_school_admin_privilege!, only: %i[new create edit update destroy]
  before_action :enroled!, only: %i[study]

  # GET /courses or /courses.json
  def index
    per_page = 10
    page = params[:page] || 1
    @courses = Course.with_school(Current.school).all.paginate(page: page, per_page: per_page)
  end

  # GET /courses/1 or /courses/1.json
  def show
    @batches = @course.batches
  end

  # GET /courses/1/study or /courses/1/study.json
  def study

  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.school = Current.school
    respond_to do |format|
      if @course.save
        flash.now[:success] = "Course was successfully created."
        format.html { redirect_to admin_course_url(@course) }
        format.json { render :show, status: :created, location: @course }
      else
        flash.now[:danger] = @course.errors.collect {|e| e.options[:message]  }.join('<br />')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        flash.now[:success] = "Course was successfully updated."
        format.html { redirect_to course_url(@course) }
        format.json { render :show, status: :ok, location: @course }
      else
        flash.now[:danger] = @course.errors.collect {|e| e.options[:message]  }.join('<br />')
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      flash[:success] = "Course was successfully removed."
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :material, :status)
    end

    def enroled!
      if ! Current.user.active_course == @course
        Rails.logger.info "[require_course to enroled!] User didnt enroled to course"
        respond_to do |format|
          flash.now[:dander] = "<h1>Unauthorized !<h1>".html_safe
          format.html { render html: "<h1>Unauthorized !<h1>".html_safe, layout: true }
          format.json { render json: {status: 401}, status: 401 }
        end
      end
    end
end

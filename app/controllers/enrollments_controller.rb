class EnrollmentsController < ApplicationController
  before_action :set_enrolment, only: %i[ complete progress ]
  before_action :active!, only: %i[study complete]

  # PUT /courses/1/complete or /courses/1/complete.json
  def complete
    @enrolment.complete
    @enrolment.save
    flash.now[:success] = "Successfully completed te course."
    redirect_to "/courses/#{@enrolment.batch.course.id}"
  end

  # PUT /courses/1/progress or /courses/1/progress.json
  def progress
    progress_percentage = params[:progress_percentage].to_f.round(2)
    if progress_percentage > @enrolment.progress.to_i
      @enrolment.progress = progress_percentage
      @enrolment.save
    end

    respond_to do |format|
      flash.now[:success] = "Progress updated"
      format.html { render html: "Progress updated".html_safe, layout: true }
      format.json { render json: {status: :ok}, status: :ok }
      format.js { render js: "" }
    end
  end

  private
  def set_enrolment
    @enrolment = Enrollment.find_by(user_id: Current.user, batch_id: params[:batch_id])
  end

  def active!
    unless @enrolment.approved?
      Rails.logger.info "[enrolement] Students enrolment is not active"
      respond_to do |format|
        flash.now[:dander] = "<h1>Unauthorized !<h1>".html_safe
        format.html { render html: "<h1>Unauthorized !<h1>".html_safe, layout: true }
        format.json { render json: {status: 401}, status: 401 }
      end
    end
  end

end

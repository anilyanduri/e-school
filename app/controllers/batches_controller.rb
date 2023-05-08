class BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy enroll ]
  before_action :require_admin_or_school_admin_privilege!, only: %i[new create edit update destroy]


  # GET /batches or /batches.json
  def index
    per_page = 10
    page = params[:page] || 1
    @batches = Batch.with_course(Current.school).all.paginate(page: page, per_page: per_page)
  end

  # GET /batches/1 or /batches/1.json
  def show
    @students = @batch.students
  end

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # GET /batches/1/edit
  def edit

  end

  def enroll
    @enrollment = Enrollment.new
    @enrollment.batch = @batch
    @enrollment.student = Current.user
    @enrollment.status = :pending
    respond_to do |format|
      if @enrollment.save
        flash.now[:success] = "Enrollment request sent successfully!"
        format.js
        format.json { render :show, status: :ok, location: @batch }
      else
        flash.now[:danger] = "Enrollment request sent failed!"
        format.js
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /batches or /batches.json
  def create
    @batch = Batch.new(batch_params)
    @batch.school = Current.school
    respond_to do |format|
      if @batch.save
        flash.now[:success] = "Batch was successfully created."
        format.html { redirect_to batch_url(@batch), notice: "Batch was successfully created." }
        format.json { render :show, status: :created, location: @batch }
      else
        flash.now[:danger] = @batch.errors.collect {|e| e.options[:message]  }.join('<br />')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batches/1 or /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        flash.now[:success] = "Batch was successfully created."
        format.html { redirect_to batch_url(@batch), notice: "Batch was successfully updated." }
        format.json { render :show, status: :ok, location: @batch }
      else
        flash.now[:danger] = @batch.errors.collect {|e| e.options[:message]  }.join('<br />')
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1 or /batches/1.json
  def destroy
    @batch.destroy

    respond_to do |format|
      flash[:success] = "Batch was successfully removed."
      format.html { redirect_to batches_url, notice: "Batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:batch).permit(:name, :course_id, :status)
    end
end

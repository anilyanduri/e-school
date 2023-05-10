require 'rails_helper'

RSpec.describe "BatchesControllers", type: :request do
  let (:admin) { create(:admin) }
  let (:school) { create(:school, created_by: admin) }
  let (:user) { create(:user) }
  let (:school_admin) { user.add_role(:school_admin, school); user }
  let (:student) { user.add_role(:student, school); user }
  let (:course) { create(:course, school_id: school.id) }
  let (:batch) { create(:batch, course_id: course.id, school_id: school.id) }
  let (:enrollment) { build(:enrollment, batch_id: batch.id, user_id: student.id, status: 1)}

  describe "GET /index" do
    it "it should be 200 for school admin" do
      login(school_admin)
      get "/admin/batches"
      expect(response).to have_http_status(200)
    end

  end

  describe "Create batch" do
    it "schold create batch" do
      login(school_admin)
      expect {
        post "/admin/batches", params: {"batch"=>{"name"=>"batch 1 for course 1", "status"=>"1", "course_id"=>course.id}}
      }.to change(Batch, :count).by(1)
    end

    it "schold fail to create batch" do
      login(student)
      expect {
        post "/admin/batches", params: {"batch"=>{"name"=>"batch 1 for course 1", "status"=>"1", "course_id"=>course.id}}
      }.not_to change(Batch, :count)
    end
  end

  describe "Update batch" do
    it "schold update batch" do
      login(school_admin)
      school
      put "/admin/batches/#{batch.id}", params: {"batch"=>{"name"=>"batch 1 for course 1 test update", "status"=>"1", "course_id"=>course.id}}
      expect(batch.reload.name).to eq "batch 1 for course 1 test update"
    end
  end

  describe "Enroll as a student" do
    it "schold let student enroll" do
      login(student)
      expect {
        put "/batches/#{batch.id}/enroll", params: {}, xhr: true
      }.to change(Enrollment, :count).by(1)
    end

    it "schold not let student enroll" do
      login(student)
      enrollment.student = student
      enrollment.batch_id = batch.id
      enrollment.status = 1
      enrollment.save
      expect {
        put "/batches/#{batch.id}/enroll", params: {}, xhr: true
      }.not_to change(Enrollment, :count)
    end
  end

  describe "endorse enrolments" do
    it "schold let admin endorse approve" do
      login(school_admin)
      enrollment.student = student
      enrollment.batch_id = batch.id
      enrollment.status = 0
      enrollment.save

      put "/admin/batches/#{batch.id}/endorse/approve", params: {"student_id"=>student.id}, xhr: true
      expect(enrollment.reload.status).to eq('approved')
    end

    it "schold let admin endorse approve" do
      login(school_admin)
      enrollment.student = student
      enrollment.batch_id = batch.id
      enrollment.status = 0
      enrollment.save

      put "/admin/batches/#{batch.id}/endorse/reject", params: {"student_id"=>student.id}, xhr: true
      expect(enrollment.reload.status).to eq('rejected')
    end
  end
end

require 'rails_helper'

RSpec.describe "BatchesControllers", type: :request do
  let (:admin) { create(:admin) }
  let (:school) { create(:school, created_by: admin) }
  let (:user) { create(:user) }
  let (:school_admin) { user.add_role(:school_admin, school); user }
  let (:student) { user.add_role(:student, school); user }
  let (:course) { create(:course, school_id: school.id) }
  let (:batch) { create(:batch, course_id: course.id, school_id: school.id) }

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
end

require 'rails_helper'

RSpec.describe "CoursesControllers", type: :request do
  let (:admin) { create(:admin) }
  let (:school) { create(:school, created_by: admin) }
  let (:user) { create(:user) }
  let (:school_admin) { user.add_role(:school_admin, school); user }
  let (:student) { user.add_role(:student, school); user }
  let (:course) { create(:course, school_id: school.id) }

  describe "GET /index" do
    it "it should be 200 for school admin" do
      login(school_admin)
      get "/admin/courses"
      expect(response).to have_http_status(200)
    end

  end

  describe "Create course" do
    it "schold create course" do
      login(school_admin)
      expect {
        post "/admin/courses", params: {"course"=>{"name"=>"Course 1", "status"=>"1", "description"=>"course 1 bla bla bla "}}
      }.to change(Course, :count).by(1)
    end

    it "schold fail to create course" do
      login(student)
      expect {
        post "/admin/courses", params: {"course"=>{"name"=>"Course 1", "status"=>"1", "description"=>"course 1 bla bla bla "}}
      }.not_to change(Course, :count)
    end
  end

  describe "Update course" do
    it "schold update course" do
      login(school_admin)
      put "/admin/courses/#{course.id}", params: {"course"=>{"name"=>"Course test update", "status"=>"1", "description"=>"course 1 bla bla bla "}}
      expect(course.reload.name).to eq "Course test update"
    end
  end

end

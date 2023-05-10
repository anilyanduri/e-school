require 'rails_helper'

RSpec.describe "Admin::SchoolsControllers", type: :request do
  let (:admin) { create(:admin) }
  let (:school) { create(:school, created_by: admin) }
  let (:user) { create(:user) }
  let (:school_admin) { user.add_role(:school_admin, school); user }
  let (:student) { user.add_role(:student, school); user }

  describe "GET /index" do
    it "it should be 200 for admin" do
      login(admin)
      get "/admin/schools"
      expect(response).to have_http_status(200)
    end

    it "it should be 200 school admin" do
      login(school_admin)
      get "/admin/schools"
      expect(response).to have_http_status(401)
    end

    it "it should be fail student" do
      login(student)
      get "/admin/schools"
      expect(response).not_to have_http_status(200)
    end
  end

  describe "Create school" do
    it "schold create school" do
      login(admin)
      expect {
        post "/admin/schools", params: {"school"=>{"name"=>"Test 2", "description"=>"", "status"=>""}}
      }.to change(School, :count).by(1)
    end

    it "schold fail to create school" do
      login(admin)
      expect {
        post "/admin/schools", params: {"school"=>{"description"=>"", "status"=>""}}
      }.not_to change(School, :count)
    end
  end

  describe "Update school" do
    it "schold update school" do
      login(admin)
      school
      put "/admin/schools/#{school.id}", params: {"school"=>{"name"=>"Test 3 update"}}
      expect(school.reload.name).to eq "Test 3 update"
    end
  end

  describe "adding admin to schools" do
    it "schold add admin to school" do
      login(admin)
      school
      user
      put "/admin/schools/#{school.id}/toogle_school_admin/", params: {user_id: user.id}, xhr: true
      expect(user.has_role?(:school_admin, school)).to eq true
    end
  end

end

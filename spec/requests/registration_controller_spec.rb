require 'rails_helper'

RSpec.describe "RegistrationControllers", type: :request do
  describe "GET new" do
    it "returns a successful response" do
      get "/register"
      expect(response).to be_successful
    end
  end

  describe "POST Create" do
    it "create a user" do
      admin = create(:admin)
      school = create(:school, created_by: admin)
      expect {
        post "/register", params: {"user"=>{"first_name"=>"test", "last_name"=>"", "email"=>"test@gmail.com", "password"=>"password"}, "school_id"=>school.id}
      }.to change(User, :count).by(1)

    end
  end
end

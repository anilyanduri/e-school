require 'rails_helper'

RSpec.describe "LoginControllers", type: :request do

  let (:admin) { create(:admin) }
  let (:school) { create(:school, created_by: admin) }
  let (:user) { create(:user) }

  describe "/login" do

    before do
      admin
      school
      user
    end

    it "schould login" do
      post "/login", params: {"user"=> {"email"=>user.email, "password"=>user.password }}
      session[:user_id].should eq user.id
    end

    it "schould fails" do
      get "/logout"
      post "/login", params: {"user"=> {"email"=>user.email, "password"=>'ss' }}
      session[:user_id].should eq nil
    end
  end


end

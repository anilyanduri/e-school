module SpecTestHelper

  def login_admin
    login(:admin)
  end

  def login(user)
    # dirty hack to create session
    post "/login", params: {"user"=> {"email"=>user.email, "password"=>user.password }}
  end

  def logout
    # dirty hack from create session
    get "/logout"
  end

end

module RequestSessionHelpers
  def session=(hash)
    env=Rack::MockRequest.env_for('/')
    env.merge! app.env_config
    setter = proc { |request_env| request_env['rack.session'].merge!(hash) }
    ActionDispatch::Session::CookieStore.new(setter, key: '_app_session').call(env)
    cookies_key_value = env['action_dispatch.cookies'].as_json.first
    cookies[cookies_key_value.first] = cookies_key_value.last
  end
end
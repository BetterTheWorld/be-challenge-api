ENV['APP_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

RSpec.describe 'The App App' do
  include Rack::Test::Methods

  after(:all) { User.destroy_all}
  let(:user_params) { generate_user_params }

  def app
    App
  end

  it "registers a user" do
    post '/register', user_params
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['token']).to be_truthy
    expect { JWT.decode(body['token'], "secret") }.to_not raise_error(JWT::DecodeError)
  end

  it "logs in a user" do
    post '/login', user_params
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['token']).to be_truthy
    expect { JWT.decode(body['token'], "secret") }.to_not raise_error(JWT::DecodeError)
  end

  it "fails to logs in a user" do
    post '/login', user_params.merge({password: 'foobar'})
    expect(last_response).not_to be_ok
    expect(last_response.status).to eq(401)
    expect(last_response.body).to eq("'Who is this? Whats your operating number?' (Bad credentials)\n")
  end

  def generate_user_params(attributes = {})
    {
      email: 'foobar@bazbat.com',
      password: 'Foobar123'
    }.merge(attributes)
  end

  def token
    JWT.encode({user_id: User.last.id}, "secret", 'HS256')
  end
end
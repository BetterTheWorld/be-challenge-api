require_relative 'config/application'

class ChallengeApi < Sinatra::Base
  SECRET = ENV['SECRET'] || "secret"

  before do
  	return unless request.env['CONTENT_TYPE'] == "application/json" 
    request.body.rewind
    params.merge!(JSON.parse request.body.read)
  end

  get "/" do
  	erb :index
  end

  post "/register" do
  	@user = User.new(params)
  	return json({token: set_token}) if @user.save
  	halt 400, "'I have a bad feelign about this' (#{@user.errors.full_messages.join(', ')})\n"
  end

  post "/login" do
  	halt 401, "'Who is this? Whats your operating number?' (Bad credentials)\n" unless good_login?
    json({token: set_token})
  end

  
  get 'reports' do
    return json([{
      name: 'Kamino Human Resources, LTD',
      location: 'Kamino'
      currency: 'Republic Credits',
      symbol: 'RCR',
      report_id: 7426,
      format: 'json'
    },{
      name: 'Mon Calamari Shipyards',
      location: 'Mon Cala',
      currency: 'Calamari Flan',
      symbol: 'CFL',
      report_id: 4738,
      format: 'csv'
    },{
      name: 'Creed Forge',
      location: 'REDACTED',
      currency: 'Republic Credits',
      symbol: 'RCR',
      report_id: 3745,
      format: 'xml'
    }].to_json)
  end

  get 'report/:report_id' do |report_id|
  	protect!
    return kamino if report_id == 7426
    return mon_cal if report_id == 4738
    return creed if report_id == 3745
    halt 404, "'Who is this? Whats your operating number?' (Not Found)\n"
  end


  private

  def set_token
  	JWT.encode({user_id: @user.id}, SECRET, 'HS256')
  end

  def token
  	@token ||= request.env['HTTP_AUTHORIZATION'].split(' ').last
  rescue StandardError => _e
  	nil
  end

  def user
  	@user ||= User.find_by_email(params[:email])
  end

  def good_login?
  	user.present? && user.password == params[:password]
  end

  def protect!
  	return nil if authorized?
  	headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
  	halt 403, "'All other information on your level is restricted'(Forbidden)\n"
  end

  def authorized?
  	return false if token.nil?
  	data = JWT.decode(token, SECRET, true, {algorithm: 'HS256'})[0]
  	@user = User.find_by(id: data['user_id'])
  	@user.present?
  rescue StandardError => _e
  	false
  end
end
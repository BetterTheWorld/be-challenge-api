require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'byebug'
require 'jwt'

set :database_file, '../config/database.yml'

# Load all models!
Dir["#{__dir__}/../models/*.rb"].each {|file| require file }

logger = Logger.new(STDOUT)
logger.formatter = proc do |severity, datetime, progname, msg|
   "#{msg}\n"
end

ActiveRecord::Base.logger = logger
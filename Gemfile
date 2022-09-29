source "https://rubygems.org"

gem "sinatra"
gem 'sinatra-contrib'
gem "sinatra-activerecord"    # for Active Record models
gem "rake"  # so we can run Rake tasks
gem 'rack-test'
gem 'rspec'
gem 'bcrypt'
gem 'jwt'
gem 'sassc'
gem "byebug"
gem 'faker'
gem 'nokogiri'
gem 'webrick'

group :production do
  # Use Postgresql for ActiveRecord
  gem 'pg'
end

group :development, :test do
  # Use SQLite for ActiveRecord
  gem 'sqlite3'
end
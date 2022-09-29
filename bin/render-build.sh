#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
echo $RAILS_ENV
echo $DATABASE_URL
echo 'Bundler finished'
bundle exec rake db:migrate
echo 'Migrate finished'

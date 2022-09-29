#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production

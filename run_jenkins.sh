#!/bin/bash

set -e

echo Setting up

mkdir ~/.bundle
touch ~/.bundle/config
echo BUNDLE_PATH: vendor/bundle > ~/.bundle/config

gem install bundler

cd user-api/

bundle config disable_local_branch_check true
bundle config --local local.candidatexyz-common ../
bundle install --path vendor/bundle

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

bundle exec puma -b tcp://127.0.0.1:3003 &

cd ../

bundle install --path vendor/bundle

echo Running tests

./bin/test

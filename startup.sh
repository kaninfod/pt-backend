#!/bin/bash


rm ./tmp/pids/server.pid && bundle exec sidekiq -d && bundle exec rails s -p 3000 -b 0.0.0.0

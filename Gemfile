source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use sqlite3 as the database for Active Record

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
gem "active_model_serializers"

#added
gem 'will_paginate'

gem 'geocoder'
gem 'mini_exiftool'
gem 'phashion'
gem "mini_magick"
gem 'ruby-filemagic'

gem 'acts_as_commentable'
gem 'acts_as_votable', '~> 0.10.0'
gem 'acts-as-taggable-on', '~> 4.0'

gem 'resque'
gem 'resque-loner'
gem 'resque-scheduler'
gem 'active_scheduler'
gem 'sinatra', github: 'sinatra/sinatra'

gem 'flickraw', '~> 0.9.8'
gem 'dropbox-sdk'

gem 'mysql2'

gem "rails-settings-cached"

gem 'jwt'
gem 'simple_command'


gem 'concurrent-ruby'



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'sqlite3'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'foreman'
  gem 'awesome_print'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

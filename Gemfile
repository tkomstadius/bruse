source 'https://rubygems.org'
# set ruby version
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# give AR some superpowers when it comes to bulk insertion
gem 'activerecord-import', '~> 0.4.0'

## frontend management
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

## frontend js libs and tools
# Use jquery as the JavaScript library
gem 'jquery-rails'
# nice javascript toolbelt
# gem 'lodash-rails'
# Turbolinks makes following links in your web application faster.
gem 'turbolinks'
# Make sure load events are thrown even though we use turbolinks
gem 'jquery-turbolinks'
# Loading indicator for turbolinks
gem 'nprogress-rails'
# Use Angular for nice dom manipulation
gem 'angularjs-rails'
# Lodash is a nice javascript toolbelt
gem 'lodash-rails'

## css/sass stuff
# icons!
gem 'font-awesome-rails'
gem 'font-awesome-sass'
# sass mixins that makes you happy
gem 'bourbon'
# normalize!
gem 'normalize-rails'
# improve support for retarded browsers!
gem 'html5shiv-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Devise for user handling
gem 'devise'
# Use omniauth for session handling
gem 'omniauth'
# dropbox omniauth strategy
gem 'omniauth-dropbox-oauth2'
# Drive omniauth strategy
gem "omniauth-google-oauth2"

# Fuzzy search for activerecord models
gem 'fuzzily', :git => 'https://github.com/danielronnkvist/fuzzily.git'

## APIs
# dropbox ruby sdk
gem 'dropbox-sdk'


# Drive ruby sdk
gem 'google-api-client'


# File uploading
gem 'carrierwave'

# Delay work
gem 'delayed_job_active_record'

## Developtment tools
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # replace the standard Rails error page
  gem 'better_errors'
  # nice clever errors
  gem 'did_you_mean'

  # generate source maps from coffee and sass files
  gem 'coffee-rails-source-maps'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # handle secrets nicely
  gem 'figaro'

  # opens emails in browser
  gem 'letter_opener'

  # testing javascript
  gem 'jasmine'
end

group :test do
  # Runs the tests
  gem 'rake'
  # capybara for emulating browser
  gem 'minitest-rails-capybara'
  # knows how to wait for angular
  gem 'capybara-angular'
  # phantomjs for capybara
  gem 'poltergeist'
  # session controll with capybara
  gem 'rack_session_access'
  # test coverage
  gem 'codeclimate-test-reporter', require: nil
end

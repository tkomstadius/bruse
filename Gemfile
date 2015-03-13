source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
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
gem 'font-awesome-sass'
# sass mixins that makes you happy
gem 'bourbon'
# normalize!
gem 'normalize-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use omniauth for session handling
gem 'omniauth'
# dropbox omniauth stategy
gem 'omniauth-dropbox-oauth2'

## APIs
# dropbox ruby sdk
gem 'dropbox-sdk'

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
  gem 'sass-rails-source-maps'

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
  # phantomjs for capybara
  gem 'poltergeist'
  # test coverage
  gem 'codeclimate-test-reporter', require: nil
end

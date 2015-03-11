source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
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

# Use omniauth for session handling
gem 'omniauth'
# dropbox omniauth stategy
gem 'omniauth-dropbox-oauth2'

## APIs
# dropbox ruby sdk
gem 'dropbox-sdk'

# development tools
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # replace the standard Rails error page
  gem 'better_errors'

  # nice clever errors
  gem 'did_you_mean'

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

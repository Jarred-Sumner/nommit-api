source 'https://rubygems.org'

ruby '2.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Facebook Auth
gem 'koala'

# Images
gem "paperclip", "~> 4.2"
gem 'aws-sdk'

# Payments
gem 'stripe'

# Phone parsing
gem 'phony_rails'

# Texting
gem 'twilio-ruby'

# Sidekiq
gem 'sidekiq'

# Bugsnag
gem "bugsnag"

# Factories
gem 'factory_girl_rails'
gem 'faker'

# Environment Variables
gem 'dotenv-rails'

# Stylin'
gem 'bourbon'
gem 'neat'

# Icons!!!11
gem 'font-awesome-sass', '~> 4.2.0'

gem 'ngannotate-rails'

group :test, :development do

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Debugging
  gem 'pry-rails'

  # Testing
  gem 'rspec-rails'

  # Tests with Stripe
  gem 'stripe-ruby-mock', '~> 1.10.1.7', require: "stripe_mock"

  gem 'database_cleaner'

  gem 'test_after_commit'

  # Deployment
  gem 'capistrano', '~> 3.1.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'

  gem 'therubyrhino',  platforms: :ruby

  gem 'did_you_mean'
end

group :production do

  # We use PostgreSQL in Production
  gem 'pg'

  # And, therubyracer, because it's difficult to get working on OS X.
  gem 'therubyracer'
end

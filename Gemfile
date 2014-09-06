source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'rspec-rails', group: :test

# Facebook Auth
gem 'koala'

# Images
gem "paperclip", "~> 4.2"

group :test, :development do

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Debugging
  gem 'pry-rails'

  # Environment Variables
  gem 'dotenv-rails'

end

group :production do

  # Heroku uses PostgreSQL
  gem 'pg'

  # Heroku's fancy deploy gem they try to set a standard for but honestly nobody gives a shit.
  gem 'rails_12factor'

  # Fancypants Application Server
  gem 'unicorn'

end

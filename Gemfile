source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.5'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '>= 3.9.0'
  # Shim to load environment variables from .env into ENV in development.
  gem 'dotenv-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Preview email in the default browser instead of sending it.
  gem 'letter_opener'
  # help you increase your application's performance by reducing the number of queries it makes.
  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 5.0'  
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'database_rewinder'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# This gem is a port of Perl's Data::Faker library that generates fake data.
gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
# Template language whose goal is to reduce the view syntax to the essential parts without becoming cryptic
gem 'slim'
# Pagination
gem 'pagy', '~> 5.10'
# A flexible authentication solution for Rails based on Warden
gem 'devise'
# Rails forms made easy.
gem 'simple_form'
# Very simple Roles library without any authorization enforcement supporting scope on resource object.
gem "rolify"
# support for multiple build strategies and multiple factories for the same class
gem "factory_bot_rails"
# best practices for client side validations
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
# State Machines adds support for creating state machines for attributes on any Ruby class.
gem 'state_machines'
gem 'state_machines-activerecord'
# Guide you in leveraging regular Ruby classes and object oriented design patterns to build a simple, robust and scalable authorization system.
gem "pundit", "~> 2.2"
# Whenever is a Ruby gem that provides a clear syntax for writing and deploying cron jobs.
gem 'whenever', require: false

gem 'sidekiq'
# Test calling external apis
gem 'vcr'
gem 'webmock'
# A gem for using PayPal API
gem 'paypal-checkout-sdk'

gem 'httparty', require: true

gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
# provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications
gem 'rack-cors'
# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem 'jwt'

gem "ruby-lsp", "~> 0.2.1", :group => :development

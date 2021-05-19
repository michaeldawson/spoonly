source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Server
gem 'rails', '~> 5.2.3'
gem 'puma', '~> 4.3'

# Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# Network
gem 'httparty'

# Environment variables
gem 'dotenv-rails'

group :development do
  # Linting
  gem 'overcommit'
  gem 'rubocop', require: false
end

group :development, :test do
  # Debugging / autoloading
  gem 'pry'
  gem 'listen'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i{mingw mswin x64_mingw jruby}

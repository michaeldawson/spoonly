source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Server
gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.11'

# Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

# Database
gem 'pg'

# Faster boot up and auto-reloading
gem 'bootsnap', '>= 1.1.0', require: false

group :development do
  # Linting
  gem 'overcommit'
  gem 'rubocop', require: false
end

group :development, :test do
  # Debugging / autoloading
  gem 'byebug', platforms: %i{mri mingw x64_mingw}
  gem 'listen'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end

gem 'tzinfo-data', platforms: %i{mingw mswin x64_mingw jruby}

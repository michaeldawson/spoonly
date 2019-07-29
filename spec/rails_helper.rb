# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'

ActiveRecord::Migration.maintain_test_schema!

WebMock.disable_net_connect!(allow_localhost: true)

# By default, Capybara only propagates errors in the test server thread that inherit from
# StandardError. Some libraries (including Webmock) raise other errors, which are silently swallowed
# in test execution. Setting this flag makes it easier to debug missing Webmock stubs, etc.
Capybara.server_errors = [Exception]

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :chrome

RSpec.configure do |config|
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, feature: true) do
    # TODO: eventually, we should start the frontend server with the test suite, but for now, just
    # require that the dev starts it manually.
    ensure_selenium_server_running
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

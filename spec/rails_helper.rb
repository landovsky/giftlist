ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/factory_girl'
require 'support/user_helper'
require 'support/delayed_job'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit

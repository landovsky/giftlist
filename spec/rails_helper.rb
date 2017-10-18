ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/factory_girl'
require 'support/user_helper'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include UserHelper
  config.include WaitForAjax, type: :feature
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Solves this issue https://stackoverflow.com/questions/8178120/capybara-with-js-true-causes-test-to-fail
  config.use_transactional_fixtures = false
  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end
end

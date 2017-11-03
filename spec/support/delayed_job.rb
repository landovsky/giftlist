# frozen_string_literal: true
RSpec.configure do |config|
  config.include UserHelper
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Solves this issue https://stackoverflow.com/questions/8178120/capybara-with-js-true-causes-test-to-fail
  config.use_transactional_fixtures = false
  config.before :each do
    # Perform DelayedJob immediatelly
    # Delayed::Worker.delay_jobs = false

    # DatabaseCleaner strategies
    DatabaseCleaner.strategy = if Capybara.current_driver == :rack_test
                                 :transaction
                               else
                                 :truncation
                               end
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end
end

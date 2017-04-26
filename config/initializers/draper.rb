# fix for /Users/landovsky/.rbenv/versions/2.3.3/lib/ruby/gems/2.3.0/gems/draper-3.0.0.pre1/lib/draper/railtie.rb:54:in `block in <class:Railtie>': uninitialized constant Draper::Railtie::ApplicationController (NameError)
# found here https://github.com/drapergem/draper/issues/573

if defined?(Rails::Console)
  require 'action_controller'
  class ApplicationController < ActionController::Base; end
end
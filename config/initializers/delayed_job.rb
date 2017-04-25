# config/initializers/delayed_job.rb
require 'delayed_duplicate_prevention_plugin'

Delayed::Backend::ActiveRecord::Job.send(:include, DelayedDuplicatePreventionPlugin::SignatureConcern)
Delayed::Worker.plugins << DelayedDuplicatePreventionPlugin



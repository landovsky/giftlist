# /lib/delayed_duplicate_prevention_plugin.rb
require 'delayed_job'
class DelayedDuplicatePreventionPlugin < Delayed::Plugin
 
  module SignatureConcern
    extend ActiveSupport::Concern

    included do
      before_validation :add_signature
      validate :manage_duplicate
    end

    attr_writer :strategy
    @@strategies = [:delete_previous_duplicate, :prevent_duplicate, :allow_duplicate]
    
    private
    def add_signature
      self.signature = generate_signature
      self.args = self.payload_object.args.to_yaml
    end

    def generate_signature
      pobj = payload_object
      if pobj.object.respond_to?(:id) and pobj.object.id.present?
        sig = "#{pobj.object.class}"
        sig += ":#{pobj.object.id}" 
      else
        sig = "#{pobj.object}"
      end
      
      sig += "##{pobj.method_name}"
      return sig
    end    
   
    def manage_duplicate
      @strategy ||= :prevent_duplicate #default strategy
      @checker = DuplicateChecker.new(self)
      if @strategy != nil
        @@strategies.include?(@strategy) ? send(@strategy) : raise("Only the following strategies are permitted: #{@@strategies}")
      end
    end
  
    def prevent_duplicate
      if @checker.duplicate?
        Rails.logger.warn "Found duplicate job(#{self.signature}), ignoring..."
        errors.add(:base, "This is a duplicate")
      end
    end
    
    def allow_duplicate 
    end

    def delete_previous_duplicate
      if @checker.duplicate?
        @checker.duplicates.each { |job| Delayed::Job.destroy(job.id) }
        logger.warn "__________: #{self.class} #{__method__} DELETED #{@checker.duplicates.count} duplicate jobs"        
      end
    end   
 
  end

  class DuplicateChecker
    attr_reader :job
    attr_accessor :duplicates

    def self.duplicate?(job)
      new(job).duplicate?
    end

    def initialize(job)
      @job = job
      @duplicates = []
      enumerate_duplicates
    end
    
    def enumerate_duplicates
      possible_dupes = Delayed::Job.where(signature: job.signature)
      possible_dupes = possible_dupes.where.not(id: job.id) if job.id.present?
      result = possible_dupes.each do |possible_dupe| 
        duplicates << possible_dupe if possible_dupe.args == job.args
      end
    end
    
    def duplicate?
      !duplicates.empty?
    end

    private

    def args_match?(job1, job2)
      normalize_args(job1.args) == normalize_args(job2.args)
    end

    def normalize_args(args)
      args.kind_of?(String) ? YAML.load(args) : args
    end
  end
end
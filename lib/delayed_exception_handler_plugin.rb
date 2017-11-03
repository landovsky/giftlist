# frozen_string_literal: true

# https://stackoverflow.com/questions/8229142/handle-errors-with-delayed-job
class DelayedExceptionHandlerPlugin < Delayed::Plugin
  callbacks do |lifecycle|
    lifecycle.around(:invoke_job) do |job, *args, &block|
      begin
        # Forward the call to the next callback in the callback chain
        block.call(job, *args)
      rescue Exception => error
        MyLogger.logme('DelayedJob error', error, level: :error)
        raise error
      end
    end
  end
end

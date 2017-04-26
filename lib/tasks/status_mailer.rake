task :status_mailer => :environment do
  jobs_count = Delayed::Job.count
  if jobs_count > 0
    puts "#{jobs_count} unprocessed jobs in #{Rails.env.upcase}"
    Delayed::Job.last.run_at < (Time.now.utc - 20.minutes) ? StatusMailer.delayed_jobs(jobs_count: jobs_count).deliver_now : puts("last job not older than 20 minutes")  
  end
  
end
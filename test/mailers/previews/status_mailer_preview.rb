# Preview all emails at http://localhost:3000/rails/mailers/status_mailer
class StatusMailerPreview < ActionMailer::Preview

def delayed_jobs
  StatusMailer.delayed_jobs(jobs_count: 5)
end

end

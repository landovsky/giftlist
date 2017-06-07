# Preview all emails at http://localhost:3000/rails/mailers/status_mailer
class StatusMailerPreview < ActionMailer::Preview

def delayed_jobs
  StatusMailer.delayed_jobs(jobs_count: 5)
end

def guest_registration_error
  user = User.create(email: "landovsky@gmail.com", role: 2)
  StatusMailer.guest_registration_error(email: user.email, error: user.errors.messages)
end

end

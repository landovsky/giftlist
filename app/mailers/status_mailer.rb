class StatusMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  default from: 'givit.cz@gmail.com'

  def delayed_jobs(options={})
    jobs_count = options[:jobs_count] if options[:jobs_count]
    jobs_count ||= "n/a"
    mail(to: "landovsky@gmail.com", subject: "Givit status: #{jobs_count} nezpracovaných mailů ve frontě [#{Rails.env}]")
  end

  def guest_registration_error(options={})
    @email = options[:email] if options[:email]
    @error = options[:error] if options[:error]
    mail(to: "landovsky@gmail.com", subject: "Givit error: pokus guesta o registraci [#{Rails.env}]")
  end

end

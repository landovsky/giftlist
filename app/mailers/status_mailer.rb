class StatusMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  default from: 'givit.cz@gmail.com'

  def delayed_jobs(options={})
    jobs_count = options[:jobs_count] if options[:jobs_count]
    jobs_count ||= "n/a"
    mail(to: "landovsky@gmail.com", subject: "Givit status: #{jobs_count} nezpracovaných mailů ve frontě [#{Rails.env}]")
  end

end

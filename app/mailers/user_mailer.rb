class UserMailer < ApplicationMailer
#http://localhost:3000/rails/mailers/user_mailer/invitation_email

  default from: 'givit.cz@gmail.com'
 
  def invitation_email(list, recipient)
    @list = list
    @recipient = recipient
    mail(to: @recipient.email, subject: "pozvánka do seznamu dárků: #{@list.occasion} / #{@list.occasion_of}")
  end

end
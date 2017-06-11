#http://localhost:3000/rails/mailers/user_mailer/invitation_email

class UserMailer < ApplicationMailer
add_template_helper(ApplicationHelper)

  default from: 'givit.cz@gmail.com'

  def invitation_email( options={} )
    @list = options[:list].decorate if options[:list]
    @recipient = options[:user].decorate if options[:user]
    @token = @recipient.token_for_list(list_id: @list.id)
    mail(to: @recipient.email, subject: "pozvánka do seznamu dárků: #{@list.occasion_name} / #{@list.occasion_of}")
  end

  def reservations_email( recipient )
    @recipient = recipient
    @lists = List.joins(:gifts).where(gifts: {user_id: @recipient.id}).distinct.decorate
    @gifts = Gift.left_joins(:list, :urls, :donor).where( gifts: { user_id: @recipient.id })
    mail(to: @recipient.email, subject: "aktuální rezervace dárků")
  end

end

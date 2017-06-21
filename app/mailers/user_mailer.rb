#http://localhost:3000/rails/mailers/user_mailer/invitation_email

class UserMailer < ApplicationMailer
add_template_helper(ApplicationHelper)

  default from: 'givit.cz@gmail.com'

  # DelayedJob neumí zvládnout zpracovat Mailer, který jako vstup dostane
  # odekorovaný objekt.
  # Objekty je potřeba dekorovat až uvnitř UserMailer metody nebo ve view.


  def invitation_email( options={} )
    @list = options[:list].decorate if options[:list]
    @recipient = options[:user].decorate if options[:user]
    @token = @recipient.token_for_list(n: 6, interval: "months", list_id: @list.id)
    mail(reply_to: @list.owner.email, to: @recipient.email, subject: "pozvánka do seznamu dárků: #{@list.occasion_name} / #{@list.occasion_of}")
  end

  def reservations_email( recipient_id )
    @recipient = User.id(recipient_id)
    @lists = List.joins(:gifts).where(gifts: {user_id: @recipient.id}).distinct.decorate
    @gifts = Gift.left_joins(:list, :urls, :donor).where( gifts: { user_id: @recipient.id })
    mail(to: @recipient.email, subject: "aktuální rezervace dárků")
  end

  def recover_password_email( recipient, token )
    @recipient = recipient
    @token = token
    mail(to: @recipient.email, subject: "postup pro obnovení hesla do Givit.cz")
  end

end

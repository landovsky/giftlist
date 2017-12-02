# frozen_string_literal: true
# http://localhost:3000/rails/mailers/user_mailer/invitation_email

class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: 'givit.cz@gmail.com'

  # DelayedJob neumi zvladnout zpracovat Mailer, ktery jako vstup dostane
  # odekorovany objekt.
  # Objekty je potreba dekorovat az uvnitr UserMailer metody nebo ve view.

  def invitation_email(options={})
    @list       = options[:list] if options[:list]
    @recipient  = options[:user] if options[:user]
    @token      = @recipient.token_for_list(n: 6, interval: 'months', list_id: @list.id)
    @list       = @list.decorate
    @recipient  = @recipient.decorate

    mail(reply_to: @list.owner.email,
         to:       @recipient.email,
         subject:  "pozvánka do seznamu dárků: #{@list.occasion_name} / #{@list.occasion_of}")
  end

  def new_gifts_email(recipient:, gift:, token:)
    @recipient = recipient
    @gift      = gift.decorate
    @list      = gift.list.decorate
    @token     = token
    mail(to: @recipient.email, subject: "podívej co nového si přeje #{@list.owner.full_name}")
  end

  def reservations_email(recipient_id)
    @recipient = User.id(recipient_id)
    @lists = List.active.joins(:gifts).where(gifts: {user_id: @recipient.id}).distinct.decorate
    @gifts = Gift.left_joins(:list, :urls, :donor).where(gifts: {user_id: @recipient.id})
    mail(to: @recipient.email, subject: 'aktuální rezervace dárků')
  end

  # per user - pro registrovane bez zalozeneho seznamu
  def registered_without_list_email(user)
    @now = user.token_for_list(answer: 'now', interval: 'days', n: 10)
    @end_of_summer = user.token_for_list(answer: 'end_of_summer', interval: 'days', n: 10)
    @end_of_autumn =  user.token_for_list(answer: 'end_of_autumn', interval: 'days', n: 10)
    @before_christmas = user.token_for_list(answer: 'before_christmas', interval: 'days', n: 10)
    @never = user.token_for_list(answer: 'never', interval: 'days', n: 10)
    mail(to: user.email, subject: 'Vzkaz z Givit.cz: založíme seznam dárků?')
  end

  def christmas_email(user)
    @ans_a = user.token_for_list(camp: 'xm17', answer: 'kost',  interval: 'days', n: 10)
    @ans_b = user.token_for_list(camp: 'xm17', answer: 'jidlo', interval: 'days', n: 10)
    @ans_c = user.token_for_list(camp: 'xm17', answer: 'darky', interval: 'days', n: 10)
    @never = user.token_for_list(camp: 'xm17', answer: 'never', interval: 'days', n: 10)

    mail(to: user.email, subject: 'Vzkaz z Givit.cz: co si přeješ pod stromeček?')
  end

  # per seznam - pro lidi se seznamem bez darku
  def list_without_gifts_email; end

  def recover_password_email(recipient, token)
    @recipient = recipient
    @token = token
    mail(to: @recipient.email, subject: 'postup pro obnovení hesla do Givit.cz')
  end
end

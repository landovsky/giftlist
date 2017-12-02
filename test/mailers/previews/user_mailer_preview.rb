class UserMailerPreview < ActionMailer::Preview

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

  def invitation_email
    rand_list = List.all.map(&:id).sample
    #@list = List.find_by(id: rand_list)
    @list = List.load_random
    rand_recipient = @list.invitees.map(&:id).sample
    #@recipient = User.find_by(id: rand_recipient).decorate
    @recipient = User.id(2)
    UserMailer.invitation_email(list: @list, user: @recipient)
  end

  def new_gifts_email_preview
    gift = Gift.load_random
    donor = gift.list.invitees.first
    token = donor.token_for_list(list_id: gift.list.id)
    UserMailer.new_gifts_email(recipient: donor, gift: gift, token: token)
  end

  def reservations_email
    user_ids = Gift.where("user_id not null").group(:user_id).map(&:user_id)
    user_ids = [1,2]
    @user = User.id(user_ids.sample)
    UserMailer.reservations_email(@user.id)
  end

  def recover_password_email
    user_ids = []
    user_ids << User.where(role: 0).sample    #guest
    user_ids << User.where(role: 2).sample    #registrovaný
    @user = User.id(user_ids.sample)
    @token = @user.token_for_list(n: 30, interval: "minutes")
    UserMailer.recover_password_email(@user, @token)
  end

  def christmas_email_preview
    user = User.id(2)
    UserMailer.christmas_email(user)
  end

  def registered_without_list_email
    UserMailer.registered_without_list_email(User.id(1))
  end
end

class UserMailerPreview < ActionMailer::Preview

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer

  def invitation_email
    rand_list = List.all.map(&:id).sample
    #@list = List.find_by(id: rand_list)
    @list = List.id(1005).decorate
    rand_recipient = @list.invitees.map(&:id).sample
    #@recipient = User.find_by(id: rand_recipient).decorate
    @recipient = User.id(2)
    UserMailer.invitation_email(list: @list, user: @recipient)
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

end

class UserMailerPreview < ActionMailer::Preview

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
  
  def invitation_email
    rand_list = List.all.map(&:id).sample
    #@list = List.find_by(id: rand_list)
    @list = List.first.decorate
    rand_recipient = @list.invitees.map(&:id).sample
    @recipient = User.find_by(id: rand_recipient).decorate
    UserMailer.invitation_email(list: @list, user: @recipient)
  end
  
  def reservations_email
    user_ids = Gift.where("user_id not null").group(:user_id).map(&:user_id)
    user_ids = [1,2]
    @user = User.id(user_ids.sample)
    UserMailer.reservations_email(@user)
  end

end

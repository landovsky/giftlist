class UserMailerPreview < ActionMailer::Preview

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
  
  def invitation_email
    rand_list = List.all.map(&:id).sample
    #@list = List.find_by(id: rand_list)
    @list = List.first
    rand_recipient = @list.donors.map(&:id).sample
    @recipient = User.find_by(id: rand_recipient)
    UserMailer.invitation_email(@list, @recipient)
  end

end

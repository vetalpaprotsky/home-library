class AdminMailer < ApplicationMailer
  default to: 'vetalpaprotsky@gmail.com'

  def new_registration(user_id)
    @user = User.find(user_id)
    @ua = 'ua'
    mail(subject: "New Registration")
  end
end

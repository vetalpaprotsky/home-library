class AdminMailer < ApplicationMailer

  AdminEmail = 'vetalpaprotsky@gmail.com'

  def new_user(user)
    @user = user
    @ua = 'ua'
    mail(to: AdminEmail, subject: "New User")
  end
end

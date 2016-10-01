class DeviseMailer < Devise::Mailer
  include MailerDefaultConfiguration
  default from: Sender
end

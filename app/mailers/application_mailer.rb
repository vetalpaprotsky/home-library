class ApplicationMailer < ActionMailer::Base
  include MailerDefaultConfiguration
  default from: Sender
  layout 'mailer'
end

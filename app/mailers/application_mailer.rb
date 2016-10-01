class ApplicationMailer < ActionMailer::Base
  default from: 'home.library.website@gmail.com'
  layout 'mailer'
  include MailerDefaultUrlOptions
end

module MailerDefaultConfiguration
  Sender = '"Home Library" <home.library.website@gmail.com>'

  private

    def default_url_options(options={})
      # calls super() to get host which is set in environment configurations
      super().merge(locale: I18n.locale).merge(options)
    end
end

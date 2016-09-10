class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # later users will have column "language" where they store their own languages
  # they will be able to choose language in settings
  # def set_locale
  #   I18n.locale = current_user.try(:locale) || I18n.default_locale
  # end

  def default_url_options(options={})
    { locale: I18n.locale }.merge options
  end
end

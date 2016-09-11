class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    if params[:locale].blank?
      I18n.locale = I18n.default_locale
      redirect_to root_path
    else
      I18n.locale = params[:locale]
    end
  end

  # Later users will have column "locale" where they store their own languages
  # and they will be able to choose them in settings
  # def set_locale
  #   I18n.locale = current_user.try(:locale) || I18n.default_locale
  # end

  def default_url_options(options={})
    { locale: I18n.locale }.merge options
  end
end

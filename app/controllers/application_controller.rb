class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  # Later users will have column "locale" where they store their own languages
  # and they will be able to choose language in settings
  # def set_locale
  #   I18n.locale = current_user.try(:locale) || I18n.default_locale
  # end

  def redirect_to_root
    redirect_to root_path
  end

  private

    def default_url_options(options={})
      { locale: I18n.locale }.merge options
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end
end

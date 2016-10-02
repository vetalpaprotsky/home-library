class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def redirect_to_root
    redirect_to root_path
  end

  private

    def default_url_options(options={})
      { locale: I18n.locale }.merge options
    end

    def set_locale
      if params[:locale].blank?
        logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
        abbr = extract_locale_from_accept_language_header
        I18n.locale = if Language.find_by(abbr: abbr).nil?
                        logger.debug "* Unknown Language"
                        I18n.default_locale
                      else
                        abbr
                      end
        logger.debug "* Locale set to '#{I18n.locale}'"
      else
        I18n.locale = params[:locale]
      end
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
end

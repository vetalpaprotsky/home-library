class Admin::SessionsController < Devise::SessionsController
  layout 'admin'

  skip_before_action :set_locale
  before_action Proc.new { I18n.locale = :en }
  before_action Proc.new { flash.clear }

  private

    def after_sign_out_path_for(resource)
      new_admin_session_path
    end

    def after_sign_in_path_for(resource)
      rails_admin_path
    end

    def default_url_options(options={})
      {}.merge options
    end
end

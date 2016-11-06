class Admin::SessionsController < Devise::SessionsController
  layout 'admin'
  before_action Proc.new { I18n.locale = :en }
end

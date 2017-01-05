class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env['omniauth.auth'])
    flash[:notice] = t('devise.sessions.signed_in')
    sign_in_and_redirect user
  end

  # Some Twitter users don't have email
  # So I need to make an workaround in order to register them
  # There's a good explanation how to do that in this video
  # Ruby on Rails Railscasts PRO #235 Devise and OmniAuth
  # alias_method :twitter, :all
  alias_method :facebook, :all
end

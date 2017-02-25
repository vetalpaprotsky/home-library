class PagesController < ApplicationController
  def letsencrypt
    render text: ENV['CERTBOT_RESPONSE']
  end
end

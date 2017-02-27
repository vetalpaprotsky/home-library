class PagesController < ApplicationController
  def letsencrypt
    text = if params[:id] == ENV['SSL_ID_1']
      ENV['SSL_RESPONSE_1']
    elsif params[:id] == ENV['SSL_ID_2']
      ENV['SSL_RESPONSE_2']
    else
      ''
    end

    render text: text
  end
end

class LocalesController < ApplicationController
  def change_locale
    cookies[:locale] = params[:language_abbr]
    redirect_to root_path locale: params[:language_abbr]
  end
end

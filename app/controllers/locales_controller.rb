class LocalesController < ApplicationController

  def change_locale
    redirect_to root_path(locale: params[:language_abbr])
  end
end

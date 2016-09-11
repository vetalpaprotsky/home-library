class LocalesController < ApplicationController

  def change_locale
    redirect_to params[:path].sub(/\A\/[a-z]{2}/, "/#{params[:new_locale]}")
  end
end

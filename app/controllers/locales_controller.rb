class LocalesController < ApplicationController
  respond_to :js

  def change_locale
    splitted_prev_path = params[:path].split('/')
    splitted_prev_path[1] = params[:new_locale]
    new_path = splitted_prev_path.join('/')
    redirect_to new_path
  end
end

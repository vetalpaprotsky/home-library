Rails.application.routes.draw do
  get '/' => 'application#redirect_to_root'

  scope "/:locale" do
    root 'books#index'
    devise_for :users
    resources :books do
      resources :reviews, except: [:index, :show], shallow: true
    end
    get '/change_locale' => 'locales#change_locale'
  end
end

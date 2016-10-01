Rails.application.routes.draw do
  get '/' => 'application#redirect_to_root'

  scope "/:locale" do
    root 'books#index'
    devise_for :users, controllers: { registrations: 'users/registrations' }
    resources :books do
      resources :comments, except: [:index, :show], shallow: true
      post 'evaluate', to: 'evaluations#evaluate'
    end
    get 'change_locale' => 'locales#change_locale'
  end
end

Rails.application.routes.draw do
  get '/' => 'application#redirect_to_root'

  devise_for :admin, skip: [:passwords, :registrations], controllers: { sessions: 'admin/sessions' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  scope "/:locale" do
    root 'books#index'
    devise_for :users, controllers: { confirmations: 'users/confirmations' }
    resources :books do
      resources :comments, except: [:index, :show], shallow: true
      post 'evaluate', to: 'evaluations#evaluate'
    end
    get 'change_locale' => 'locales#change_locale'
  end
end

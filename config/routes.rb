Rails.application.routes.draw do
  get '/' => 'application#redirect_to_root'

  devise_for :admin, skip: [:passwords, :registrations], controllers: { sessions: 'admin/sessions' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '/:locale' do
    root 'books#index'

    devise_for :users, controllers: {
                         confirmations: 'users/confirmations',
                         passwords: 'users/passwords'
                     }, skip: :omniauth_callbacks

    resources :books do
      resources :comments, except: [:index, :show], shallow: true
      post 'evaluate', to: 'evaluations#evaluate'
    end
    get 'change_locale' => 'locales#change_locale'
  end

  get '/.well-known/acme-challenge/kE7jE7gLsCUdcS1OXtvVSgS1MzFZJnPLkPTAo2b4gEs' => 'pages#letsencrypt'
end

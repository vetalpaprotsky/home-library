Rails.application.routes.draw do
  get '/' => 'books#index'

  devise_for :admin, skip: [:passwords, :registrations], controllers: { sessions: 'admin/sessions' }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '/:locale' do
    root 'books#index'

    devise_for :users, controllers: {
                         confirmations: 'users/confirmations',
                         passwords: 'users/passwords',
                         registrations: 'users/registrations'
                     }, skip: :omniauth_callbacks

    get 'my_books', to: 'books#my_books', as: :my_books

    resources :books do
      resources :comments, except: [:index, :show], shallow: true
      post 'evaluate', to: 'evaluations#evaluate'
    end
    get 'change_locale' => 'locales#change_locale'
  end
end

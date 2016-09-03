Rails.application.routes.draw do
  root "books#index"
  devise_for :users
  resources :books do
    resources :reviews, except: [:index, :show], shallow: true
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'videos#index'

  resources :videos
  resources :peoples, only: :show
end

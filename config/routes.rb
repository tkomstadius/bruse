Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  resources :bruse_files

  # recieve auth callback
  match '/auth/:provider/callback', via: [:get, :post], to: 'sessions#create'
  # logout
  match '/signout', via: [:get, :post], to: 'sessions#destroy'
end

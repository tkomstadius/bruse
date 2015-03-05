Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  # recieve auth callback
  match '/auth/:provider/callback', via: [:get, :post], to: 'sessions#create'
  # logout
  match '/signout', via: [:get, :post], to: 'sessions#destroy'

  # files
  scope '/service/:identity_id' do
    resources :files, only: [:create, :new, :destroy], path_names: {new: 'add'}
    get '/files/browse', to: 'files#browse'
  end
end

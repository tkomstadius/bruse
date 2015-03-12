Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  # User profile
  get '/user', to: 'users#show', as: 'profile'
  get '/user/terminate', to: 'users#terminate', as: 'terminate_user'

  delete '/provider/:id', to: 'identities#destroy', as: 'destroy_provider'
  delete '/user', to: 'users#destroy', as: 'destroy_user'

  # recieve auth callback
  match '/auth/:provider/callback', via: [:get, :post], to: 'sessions#create'
  # logout
  match '/signout', via: [:get, :post], to: 'sessions#destroy'

  # files
  scope '/service/:identity_id' do
    resources :files, only: [:create, :new, :destroy, :index], path_names: {new: 'add'}
    get '/files/browse', to: 'files#browse'
  end
end

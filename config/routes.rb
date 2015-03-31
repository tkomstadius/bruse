Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  # User
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks',
                                       registrations: 'user/registrations' }
  get '/user', to: 'user/users#show', as: 'profile'
  get '/users/terminate', to: 'user/users#terminate', as: 'terminate_user'
  delete '/users', to: 'user/users#destroy', as: 'destroy_user'

  delete '/provider/:id', to: 'identities#destroy', as: 'destroy_provider'

  # files
  scope '/service/:identity_id' do
    resources :files, only: [:create, :new, :destroy, :index], path_names: {new: 'add'}
    # delete folder
    post '/files/folder/delete', to: 'files#destroy_folder'
    get '/files/browse', to: 'files#browse'
    get '/files/download/:id', to: 'files#download_url'
  end
  get '/get/:download_hash/:name', to: 'files#download', :via => :all

  # search
  get '/search/:query', to: 'search#find', :defaults => { :format => 'json' }
  get '/search', to: 'search#home', as: 'search'
end

Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  resources :bruse_files

  resources :tags, except: :new


  get '/tag/new/:file_id', to: 'tags#new', as: 'new_tag'


  delete '/file/:file_id/tag/delete/:id', to: 'tags#destroy', as: 'destroy_tag'


  # User profile
  get '/user', to: 'users#show', as: 'profile'
  get '/user/terminate', to: 'users#terminate', as: 'terminate_user'

  delete '/provider/:id', to: 'identities#destroy', as: 'destroy_provider'
  delete '/user', to: 'users#destroy', as: 'destroy_user'

  # recieve auth callback
  match '/auth/:provider/callback', via: [:get, :post], to: 'sessions#create'
  match '/auth/failure', via: [:get, :post], to: 'pages#omniauth_failure', as: 'omniauth_failure'
  # logout
  match '/signout', via: [:get, :post], to: 'sessions#destroy'

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
  post '/search', to: 'search#find', :defaults => { :format => 'json' }, as: 'search_find'
  get '/search', to: 'search#home', as: 'search'

  # upload
  post '/upload', to: 'bruse_files#upload', as: 'upload'

end

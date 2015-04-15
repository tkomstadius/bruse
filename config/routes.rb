Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#show', page: 'home'

  resources :tags, except: :new

  get '/tag/new/:file_id', to: 'tags#new', as: 'new_tag'
  delete '/file/:file_id/tag/delete/:id', to: 'tags#destroy', as: 'destroy_tag'

  # User
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks',
                                       registrations: 'user/registrations' }
  get '/user', to: 'user/users#show', as: 'profile'
  get '/users/terminate', to: 'user/users#terminate', as: 'terminate_user'
  delete '/users', to: 'user/users#destroy', as: 'destroy_user'

  # Provider
  delete '/provider/:id', to: 'identities#destroy', as: 'destroy_provider'

  # all controllers located in the files folder
  scope module: :files do
    scope '/service/:identity_id' do
      # get folder contents
      get '/files/browse', to: 'browse#browse'
      # get a url used for downloading a file
      get '/files/download/:id', to: 'download#download_url'
      resources :files, except: :update, path_names: { new: 'add' }
    end
    # downloads a file
    get '/get/:download_hash/:name', to: 'download#download', :via => :all

    post '/upload', to: 'browse#upload', as: 'upload'

    get '/files', to: 'files#show_all', as: 'bruse_files'

  end
  # search
  post '/search', to: 'search#find', :defaults => { :format => 'json' }, as: 'search_find'
  get '/search', to: 'search#home', as: 'search'

end

Rails.application.routes.draw do
  # root
  root 'pages#show', page: 'home'

  # User
  devise_for :users, controllers: { omniauth_callbacks: 'user/omniauth_callbacks',
                                    registrations:      'user/registrations',
                                    passwords:          'user/passwords' }
  get '/user', to: 'user/users#show', as: 'profile'
  get '/users/terminate', to: 'user/users#terminate', as: 'terminate_user'
  delete '/users', to: 'user/users#destroy', as: 'destroy_user'

  # Tags
  resources :tags, except: [:new, :destroy]
  delete '/files/:file_id/tag/delete/:id', to: 'tags#destroy', as: 'destroy_tag'
  get '/tag/new/:file_id', to: 'tags#new', as: 'new_tag'

  # Provider
  delete '/provider/:id', to: 'identities#destroy', as: 'destroy_provider'

  # all controllers/methods located in the files folder
  scope module: :files do
    # all urls beginning with /service/number/...
    scope '/service/:identity_id' do
      # get folder contents
      get '/files/browse', to: 'browse#browse'
      # get a url used for downloading a file
      get '/files/download/:id', to: 'download#download_url'
      resources :files, except: [:update, :create], path_names: { new: 'add' }
      post '/files', to: 'create#create'
      get '/files/add/tag', to: 'create#new'
    end

    # update file
    put '/files/update', to: 'files#update', as: 'update_file'

    # downloads a file
    get '/get/:download_hash(/:name)', to: 'download#download', via: :all

    # previews a file
    get '/preview/:id', to: 'download#preview', via: :all

    # uploads
    post '/create_file', to: 'create_text#create_from_text', defaults: { format: 'json' }
    post '/upload', to: 'upload#upload', as: 'upload'
    post '/upload_drop', to: 'upload#upload_from_base64', as: 'upload_drop'

    # user file index
    get '/files', to: 'files#show_all', as: 'bruse_files'
  end
  # search
  post '/search', to: 'search#find', defaults: { format: 'json' }, as: 'search_find'
  get '/search', to: 'search#home', as: 'search'
end

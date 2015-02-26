Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # root 'welcome#index'

  # recieve auth callback
  match '/auth/:provider/callback', to: 'sessions#create'
  # logout
  match '/signout', to: 'sessions#destroy'
end

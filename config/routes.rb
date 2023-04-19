Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get "blobs/index", to: "blobs#index"
  get '/blobs/:id', to: 'blobs#show'

  post "blobs/create", to: "blobs#create"
end

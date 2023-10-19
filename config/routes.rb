Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # resources :users, only: [:show] #for ease of understanding, we will skip resoruces for now
      get '/users/:id', to: 'users#show'
      get 'puzzles', to: 'puzzles#index'
    end
  end
end

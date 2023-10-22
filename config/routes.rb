Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # resources :users, only: [:show] #for ease of understanding, we will skip resoruces for now
      put '/puzzles', to: 'puzzles#index'

      post '/users/:user_id/login', to: 'sessions#create'
      delete '/users/:user_id/logout', to: 'sessions#destroy'

      get '/users/:user_id', to: 'users#show'
      get '/users/:user_id/dashboard', to: 'users#dashboard'
      post '/users', to: 'users#create'

      get '/users/:user_id/puzzles', to: 'users/puzzles#index'
      get '/users/:user_id/puzzles/:puzzle_id', to: 'users/puzzles#show'
      post '/users/:user_id/puzzles', to: 'users/puzzles#create'
      patch '/users/:user_id/puzzles/:puzzle_id', to: 'users/puzzles#update'

      post '/users/:user_id/loans', to: 'users/loans#create'
      patch '/users/:id/loans/:loan_id', to: 'users/loans#update'
    end
  end
end

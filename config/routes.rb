Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      # resources :users, only: [:show] #for ease of understanding, we will skip resoruces for now
<<<<<<< HEAD
      get 'puzzles', to: 'puzzles#index'
      get '/users/:user_id/puzzles/:puzzle_id', to: 'users/puzzles#show'
=======
>>>>>>> 49ab3114a5b0246e3d8308ca61eb0cca1b7ccb3b
      get '/users/:user_id', to: 'users#show'
      get '/users/:user_id/dashboard', to: 'users#dashboard'

      get '/users/:user_id/puzzles', to: 'users/puzzles#index'
      get '/users/:user_id/puzzles/:puzzle_id', to: 'users/puzzles#show'
      patch '/users/:user_id/puzzles/:puzzle_id', to: 'users/puzzles#update'
    end
  end
end

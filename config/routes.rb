Rails.application.routes.draw do
  # get 'puzzles/index'
    get '/api/v1/puzzles'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :puzzles, only: :index
end
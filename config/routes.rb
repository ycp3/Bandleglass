Rails.application.routes.draw do
  get "/summoners/:region/:name", to: "summoners#show"
  resources :matches, param: :match_id, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

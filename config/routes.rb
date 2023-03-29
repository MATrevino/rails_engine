Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :items, only: [:show] do
        get "find", to: "item/search#show"
      end
      resources :customers, only: [:index]
      resources :invoices, only: [:index]
      resources :merchants, only: [:index, :show]  do
        get "items", to: "merchant/items#index"
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get "merchant", to: "item/merchant#show"
      end
    end
  end

  # get "/api/v1/items/find", to: "item/search#show"
end

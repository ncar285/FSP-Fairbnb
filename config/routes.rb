Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api, defaults: {format: :json} do 
    resources :users, only: [:create, :index] do
      collection do
        get 'checkEmail'
      end
    end
    resource :session, only: [:show, :create, :destroy]
    resources :listings, only: [:show, :index]
    resources :reviews, only: [:show, :create, :update, :destroy]
  end

  post 'api/test', to: 'application#test'

  get '*path',
    to: 'static_pages#frontend', constraints: 
    lambda {|req| !req.xhr? && req.format.html? }

  root to: 'static_pages#frontend'

end

# api/sessions#create {:format=>:json}
# api_test POST   /api/test(.:format)   
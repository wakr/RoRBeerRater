Rails.application.routes.draw do
  resources :memberships

  resources :beer_clubs

  resources :users
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :beers
  resources :breweries
  get '/', to: 'breweries#index'
  get 'kaikki_bisset', to:'beers#index'
 # get 'ratings', to: 'ratings#index'
 # get 'ratings/new', to:'ratings#new'
 # post 'ratings', to:'ratings#create'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  root to: 'breweries#index'
  resource :session, only: [:new, :create, :delete]
end

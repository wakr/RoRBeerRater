Rails.application.routes.draw do
  resources :styles

  resources :memberships

  resources :beer_clubs

  resources :users
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :beers
  resources :breweries
  resources :places, only:[:index, :show]

  get '/', to: 'breweries#index'
  get 'kaikki_bisset', to:'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  root to: 'breweries#index'
  resource :session, only: [:new, :create, :delete]
  post 'places', to:'places#search'
end

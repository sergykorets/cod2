Rails.application.routes.draw do
  root 'pages#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, :controllers => { registrations: 'registrations' }

  get '/player/:id', to: 'users#info'
  get '/home', to: 'pages#index'
end
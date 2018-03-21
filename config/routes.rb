Rails.application.routes.draw do
  devise_for :users
  resources :registered_applications
  root 'welcome#index'
end

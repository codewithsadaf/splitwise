Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :expenses, only: %i[new create destroy]

  root to: "static#dashboard"
  get 'people/:id', to: 'static#person', as: 'person'
end

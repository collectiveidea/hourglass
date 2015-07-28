Rails.application.routes.draw do
  resource :statusboard, only: [:show], defaults: { format: :json }

  resource :slack, only: [:show], defaults: { format: :text }

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

  root to: redirect("users", status: 302)
end

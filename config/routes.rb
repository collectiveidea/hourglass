Rails.application.routes.draw do
  resource :statusboard, only: [:show], defaults: { format: :json }

  resource :slack, only: [:show], defaults: { format: :text }
end

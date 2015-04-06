Rails.application.routes.draw do
  resource :statusboard, only: [:show], defaults: { format: :json }
end

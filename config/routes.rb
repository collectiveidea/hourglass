Rails.application.routes.draw do
  resource :statusboard, only: [:show], defaults: { format: :json }

  resource :slack, only: [:show], defaults: { format: :text }

  resources :responsibilities, except: [:show] do
    put :reorder, on: :member
  end
  resources :users, except: [:show]
  resources :teams, except: [:show]

  scope controller: "calendars", format: "ics" do
    get :pto
  end

  root to: redirect("users", status: 302)
end

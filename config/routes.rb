Hourglass::Application.routes.draw do
  resources :projects, except: :show
  resource :statusboard, only: :show, defaults: {format: :json}

  root to: redirect("/projects")
end

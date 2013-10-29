Hourglass::Application.routes.draw do
  resources :projects, only: [:new, :create, :index]

  root to: redirect("/projects")
end

Hourglass::Application.routes.draw do
  resources :projects, only: [:index, :new, :create, :edit, :update]

  root to: redirect("/projects")
end

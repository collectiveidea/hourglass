Hourglass::Application.routes.draw do
  resources :projects, except: :show

  root to: redirect("/projects")
end

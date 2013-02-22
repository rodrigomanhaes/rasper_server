RasperServer::Application.routes.draw do
  resources :reports, only: [:create] do
    post :generate, on: :member
  end
end
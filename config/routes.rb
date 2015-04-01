Rails.application.routes.draw do
  resources :hosts do
    resources :resources, only: [:edit, :update, :destroy] do
      member do
        post :check
      end
    end
  end

  resources :resources, only: [:create]

  get 'resources' => 'resources#show'

  root to: 'dashboards#index'
end

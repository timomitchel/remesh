Rails.application.routes.draw do
  resources :conversations, only: [:index, :show, :new, :create] do
    resources :messages, only: [:new, :create]
  end

  resources :messages, only: [] do
    resources :thoughts, only: [:new, :create]
  end

  get "messages/search", to: "messages#search", as: :search_messages

  root "conversations#index"

  get "up" => "rails/health#show", as: :rails_health_check

  get ".well-known/appspecific/com.chrome.devtools.json", to: proc { [204, {}, []] }
end

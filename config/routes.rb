Rails.application.routes.draw do
  resources :pessoas, only: %i(create show index)

  get '/contagem-pessoas', to: 'contagem_pessoas#show', as: :contagem_pessoas
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

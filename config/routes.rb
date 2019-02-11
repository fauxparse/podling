Podling::Engine.routes.draw do
  namespace :admin do
    resources :episodes
  end

  resources :episodes, only: %i[index show]
  root to: 'episodes#index'
end

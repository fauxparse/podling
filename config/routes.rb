Podling::Engine.routes.draw do
  resources :episodes
  root to: 'episodes#index'
end

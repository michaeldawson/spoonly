Rails.application.routes.draw do
  get '/', to: redirect('/recipes')
  resources :recipes, only: %i{index show}
end

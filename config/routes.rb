Rails.application.routes.draw do
  get '/game', to: 'lwg#game'

  get '/score', to: 'lwg#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

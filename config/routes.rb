Rails.application.routes.draw do
  get '/',  to: "top#result"
  get '/privacy', to: "top#privacy"
  get '/support', to: "top#support"
  get '/terms', to: "top#terms"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end

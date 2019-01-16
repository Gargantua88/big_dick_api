Rails.application.routes.draw do
  resources :materials, except: [:show]

  get '/materials/:id', to: 'materials#show', constraints: { id: /[0-9]+/ }

  # Получение материала по относительной ссылке, которая может содержать “/” (/api/topics/относительная/ссылка.html)
  get '/materials/*link', to: 'materials#show', constraints: { link: /.+/ }
end
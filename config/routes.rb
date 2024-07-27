Target::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'
  
  get '/criar-conta' => 'frontend/registrations#new', as: :new_member
  get '/criar-conta-pagamento' => 'frontend/registrations#new_member_payment', as: :new_member_payment
  post 'criar' => 'frontend/registrations#create', as: :create_member
  post 'criar-pagamento-membro' => 'frontend/registrations#create_member_and_payment', as: :create_member_and_payment
  get '/check_payment_public' => 'frontend/public#check_payment', as: :check_payment_public
  post 'check_phone', to: 'frontend/public#check_phone'
  post 'check_phone_numbers', to: 'frontend/public#check_phone_numbers'
  get '/comprar-bilhete/:id' => 'frontend/public#purchase', as: :new_purchase
  get '/campanhas' => 'frontend/public#events'
  post '/pagamento' => 'frontend/public#pix', as: :validar_pagamento_publico
  get '/pagamento-membro' => 'frontend/public#pix_member', as: :validar_pagamento
  get 'comprar-ticket/:id' => 'frontend/public#new', as: :new_ticket
  put 'comprar_public' => 'frontend/public#create', as: :lottery_tickets_public
  get '/meus-titulos' => 'frontend/public#meus_titulos'
  get '/numeros-selecionados' => 'frontend/public#numbers', as: :numbers_after_approved
  post '/meus-numeros' => 'frontend/public#search_numbers', as: :procurar_numeros
  get '/comunicados' => 'frontend/public#comunications'
  get '/ganhadores' => 'frontend/public#winners'
  get '/termo' => 'frontend/public#term'
  get '/erro-servidor-pagamento' => 'frontend/public#error', as: :error
  put '/numeros-esgotados' => 'frontend/public#finished'
  get '/numeros-esgotados' => 'frontend/public#finished' , as: :finished_numbers

  get '/meus-pagamentos' => 'frontend/public#meus_titulos' , as: :my_payments
  get '/meus-pagamentos/:id' => 'frontend/public#pix' , as: :my_payment

  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  devise_for :user, path: 'admin'
  namespace :admin do
    resources :pages, :newsletters, :links, :users, :roles, :permissions, :localizations, :phones, :social_networks,
    :analytics, :videos

    get 'edit_password', to: 'users#edit_password',  as: :edit_password
    patch 'update_password', to: 'users#update_password',  as: :update_password

    put 'active_lottery/:slug', to: 'lotteries#active_lottery', as: :active_lottery

    

    resources :banner_categories do
      resources :banners do
        collection do
          post :update_position
        end
      end
    end

   
    
    resources :lotteries do
      collection do
        get 'search' => 'lotteries#search', as: :search
      end
      get 'to_rank', to: 'lotteries#to_rank',  as: :to_rank
    end 
    
    
    resources :members do
      collection do
        get 'search' => 'members#search', as: :search
        post 'search_by_ticket'
      end
    end  

    resources :payments do
      collection do
        get 'search' => 'payments#search', as: :search
      end
    end 

    resources :failures do
      collection do
        get 'search' => 'failures#search', as: :search
      end
    end 

    resources :messages do
      collection do
        get 'search' => 'messages#search', as: :search
      end
    end 

    

    root to: 'dashboard#index'
  end 

   
  root to: 'frontend/public#events'
end

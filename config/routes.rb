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
  get '/numeros-selecionados' => 'frontend/public#numbers'
  post '/meus-numeros' => 'frontend/public#search_numbers', as: :procurar_numeros


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
      end
    end  

    resources :payments do
      collection do
        get 'search' => 'payments#search', as: :search
      end
    end 


    resources :notice_categories do
      resources :notices do
        collection do
          get 'search' => 'notices#search', as: :search
        end
      end
    end

    root to: 'dashboard#index'
  end 

   
  root to: 'frontend/home#index'
end

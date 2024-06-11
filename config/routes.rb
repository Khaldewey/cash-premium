Target::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'
  
  get '/check_payment_public' => 'frontend/public#check_payment', as: :check_payment_public
  post 'check_phone', to: 'frontend/public#check_phone'
  get '/comprar-bilhete/:id' => 'frontend/public#purchase', as: :new_purchase
  get '/campanhas' => 'frontend/public#index'
  post '/pagamento' => 'frontend/public#pix', as: :validar_pagamento_publico
  get 'comprar-ticket/:id' => 'frontend/public#new', as: :new_ticket
  put 'comprar_public' => 'frontend/public#create', as: :lottery_tickets_public

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

    resources :article_categories do
      resources :articles do
        resources :images do
          collection do
            post :update_position
          end
        end
      end
    end

    resources :email_categories do
      resources :email_contacts
    end 
    

    resources :banner_categories do
      resources :banners do
        collection do
          post :update_position
        end
      end
    end

    resources :pages do
      resources :page_images do
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

    resources :blogs do
      collection do
        get 'search' => 'blogs#search', as: :search
      end
    end 

    resources :tutorials do
      collection do
        get 'search' => 'tutorials#search', as: :search
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


  devise_for :member, path: 'area-member', controllers: {registrations: 'member/registrations', sessions: 'member/sessions',  passwords: 'member/custom_passwords'}
  namespace :member, path: "area-member" do
    get '/editar-senha' => 'edit_password#new', as: :edit_password
    patch '/editar-senha/password' => 'edit_password#update_password', as: :update_password
    post '/pagamento' => 'home#pix', as: :validar_pagamento
    get 'comprar-ticket/:id' => 'home#new', as: :new_ticket
    get 'campanhas' => 'home#lotteries', as: :lotteries
    put 'comprar' => 'home#create', as: :lottery_tickets
    # root to: 'home#redirect_based_on_auth'
    root to: 'home#index'
  end

  # devise_scope :member do
  #   root to: 'member/sessions#new'
  # end 
  root to: 'frontend/public#index'
end

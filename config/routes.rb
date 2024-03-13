Target::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'

  get '/contato' => 'frontend/contact#new', as: :contact

  post '/contato/enviar' => 'frontend/contact#send_contact', as: :send_contact

  post '/newsletter/cadastrar' => 'frontend/home#create_newsletter', as: :create_newsletter

  get '/pagina/:slug' => 'frontend/pages#show', as: :page

  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  devise_for :user, path: 'admin'
  namespace :admin do
    resources :pages, :newsletters, :links, :users, :roles, :permissions, :localizations, :phones, :social_networks,
    :analytics, :videos

    get 'edit_password', to: 'users#edit_password',  as: :edit_password
    patch 'update_password', to: 'users#update_password',  as: :update_password

    put 'notice_is_active/:slug', to: 'notices#is_active', as: :notice_is_active
    put 'notice_is_highlight/:slug', to: 'notices#is_highlight', as: :notice_is_highlight

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


  devise_for :member, path: 'area-member', controllers: {registrations: 'member/registrations'}
  namespace :member, path: "area-member" do
    
    get '/editar-senha' => 'edit_password#new', as: :edit_password
    patch '/editar-senha/password' => 'edit_password#update_password', as: :update_password
    
    root to: 'home#index'
  end

  root to: 'frontend/home#index'
end

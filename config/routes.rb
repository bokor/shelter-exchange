ShelterExchangeApp::Application.routes.draw do

  # Shared Functions
  #----------------------------------------------------------------------------
  namespace :shared do

    # Shared :: Breeds
    #----------------------------------------------------------------------------
    resources :breeds, :only => [:auto_complete] do
      get :auto_complete, :on => :collection
    end

    # Shared :: Shelters
    #----------------------------------------------------------------------------
    resources :shelters, :only => [:auto_complete] do
      get :auto_complete, :on => :collection
    end
  end
  #----------------------------------------------------------------------------


  # Application - Routes for *subdomain*.shelterexchange.org
  #----------------------------------------------------------------------------
  constraints(Subdomains::App) do

    # Notes
    #----------------------------------------------------------------------------
    resources :notes, :only => [:show, :create, :edit, :update, :destroy] do
      resources :documents, :only => [:create, :destroy]
    end

    # Status Histories
    #----------------------------------------------------------------------------
    resources :status_histories, :only => [:edit, :update] do
      resources :comments
    end

    # Comments
    #----------------------------------------------------------------------------
    resources :comments, :only => [:create, :edit, :update, :destroy]

    # Items
    #----------------------------------------------------------------------------
    resources :items

    # Reports
    #----------------------------------------------------------------------------
    resources :reports do
      collection do
        get :custom
        get :status_by_month_year
        get :type_by_month_year
      end
    end

    # Locations
    #----------------------------------------------------------------------------
    resources :locations, :only => [:create, :edit, :update, :destroy] do
      collection do
        get :find_all
      end
    end

    # Accommodations
    #----------------------------------------------------------------------------
    resources :accommodations, :except => [:show] do
      collection do
        get :search
        get :filter_by_type_location
      end
    end

    # Tasks
    #----------------------------------------------------------------------------
    resources :tasks, :except => [:show] do
      post :complete, :on => :member
    end

    # Alerts
    #----------------------------------------------------------------------------
    resources :alerts, :except => [:show] do
      post :stop, :on => :member
    end

    # Communities
    #----------------------------------------------------------------------------
    resources :communities do
      collection do
        get :filter_notes
        get :find_animals_in_bounds
        get :find_animals_for_shelter
      end
    end

    # Maps
    #----------------------------------------------------------------------------
    resources :maps, :only => [:overlay]

    # Transfers
    #----------------------------------------------------------------------------
    resources :transfers, :except => [:index, :show]

    # Contacts
    #----------------------------------------------------------------------------
    resources :contacts do
      resources :notes
      collection do
        get :search
        get :filter_by_last_name_role
        get :filter_animals_by_status
        get :find_by_full_name
        put :import
        get :export
      end
    end

    # Parents
    #----------------------------------------------------------------------------
    resources :parents, :only => [:index] do

      collection do
        get :search
      end

      member do
        post :migrate
      end
    end

    # Photos
    #----------------------------------------------------------------------------
    resources :photos, :only => [:destroy]

    # Documents
    #----------------------------------------------------------------------------
    resources :documents, :only => [:destroy]

    # Animals
    #----------------------------------------------------------------------------
    resources :animals do
      resources :notes
      resources :alerts
      resources :tasks
      resources :photos, :only => [:create, :destroy] do
        get :refresh_gallery, :on => :collection
      end

      member do
        match :print, :via => [:get, :post]
      end

      collection do
        get :search
        get :filter_notes
        get :filter_by_type_status
        get :find_animals_by_name
        get :auto_complete
      end
    end

    # Shelters
    #----------------------------------------------------------------------------
    resources :shelters, :only => [:index, :edit, :update]

    # Wish Lists
    #----------------------------------------------------------------------------
    resources :wish_lists, :only => [:edit, :update]

    # Capacities
    #----------------------------------------------------------------------------
    resources :capacities

    # Account Settings
    #----------------------------------------------------------------------------
    resources :settings, :only => [:index]
    match '/settings/:tab' => 'settings#index', :as => :setting

    resources :token_authentications, :only => [:create, :destroy]


    # Exports
    #----------------------------------------------------------------------------
    resources :exports, :only => [:index]

    # Integrations
    #----------------------------------------------------------------------------
    resources :integrations, :only => [:create, :destroy]


    # Announcements
    #----------------------------------------------------------------------------
    resources :announcements do
      post :hide, :on => :collection
    end

    # Users
    #----------------------------------------------------------------------------
    resources :users, :except => [:show, :new, :create] do
      member do
        put :change_password
        post :change_owner
        get :valid_token
      end
      post :invite, :on => :collection
    end


    devise_for :users,
               :path => "",
               :path_names => { :sign_in => "login", :sign_out => "logout",
                                :confirmation => "confirmation", :invitation => "invitation" }


    # Dashboard
    #----------------------------------------------------------------------------
    match "/dashboard", :to => 'dashboard#index'

    # ROOT
    #----------------------------------------------------------------------------
    root :to => redirect("/dashboard")
  end



#--------------------------------------------------------------------------------------------------------------------------------------------------------




  # Admin - Routes for manage.shelterexchange.org
  #----------------------------------------------------------------------------
  constraints(Subdomains::Admin) do

    namespace :admin do

      # Admin :: Dashboard
      #----------------------------------------------------------------------------
      resources :dashboard, :only => [:index]

      # Admin :: Shelters
      #----------------------------------------------------------------------------
      resources :shelters, :only => [:index, :show, :edit, :update] do
        get :live_search, :on => :collection
      end

      # Admin :: Animals
      #----------------------------------------------------------------------------
      resources :animals, :only => [:index] do
        get :live_search, :on => :collection
      end

      # Admin :: Integrations
      #----------------------------------------------------------------------------
      resources :integrations, :only => [:index]

      # Admin :: Users
      #----------------------------------------------------------------------------
      resources :users, :only => [:index] do
        get :live_search, :on => :collection
      end

      # Admin :: Announcements
      #----------------------------------------------------------------------------
      resources :announcements, :except => [:new]

      # Admin :: Accounts
      #----------------------------------------------------------------------------
      resources :accounts, :only => [:edit, :update]

      # Admin :: Export
      #----------------------------------------------------------------------------
      resources :exports, :only => [:index]
      match "exports/:export_type" => "exports#show", :as => :export, :defaults => { :format => :csv }, :via => [:get]

      # Admin :: Reports
      #----------------------------------------------------------------------------
      resources :reports do
        collection do
          get :custom
          get :status_by_month_year
          get :type_by_month_year
        end
      end
    end

    # Admin :: Owners :: Devise
    #----------------------------------------------------------------------------
    match '/login' => redirect('/admin/login')
    devise_for :owners, :path => "admin", :controllers => { :sessions => "admin/owners/sessions" },
                        :path_names => { :sign_in => "login", :sign_out => "logout" }



    # Root
    #----------------------------------------------------------------------------
    root :to => redirect("/admin/dashboard")
  end



#--------------------------------------------------------------------------------------------------------------------------------------------------------



  # Api - Routes for api.shelterexchange.org
  #----------------------------------------------------------------------------
  constraints(Subdomains::Api) do

    namespace :api, :path => "/" do

      # Api :: Animals
      #----------------------------------------------------------------------------
      resources :animals, :only => [:index, :show]
      match '/:version/animals' => 'animals#index'
      match '/:version/animals/:id' => 'animals#show'

    end

  end


#--------------------------------------------------------------------------------------------------------------------------------------------------------



  # Public - Routes for www.shelterexchange.org or shelterexchange.org
  #----------------------------------------------------------------------------
  constraints(Subdomains::Public) do

    namespace :public, :path => "/" do

      # Public :: Accounts
      #----------------------------------------------------------------------------
      resources :accounts, :only => [:new, :create] do  #:index, add if the error has been fixed
        get :registered, :on => :member
      end
      get "signup" => "accounts#new", :path => :signup
      post "signup" => "accounts#create", :path => :signup


      # Public :: Save A Life
      #----------------------------------------------------------------------------
      resources :save_a_life do
        collection do
          get :find_animals_in_bounds
        end
      end

      # Public :: Help A Shelter
      #----------------------------------------------------------------------------
      resources :help_a_shelter, :only => [:index, :show] do
        collection do
          get :search_by_shelter_or_rescue_group
          get :find_shelters_in_bounds
          get :find_animals_for_shelter
        end
      end

      # Public :: Login
      #----------------------------------------------------------------------------
      devise_for :users, :path => "", :controllers => { :sessions => "public/users/sessions", :passwords => "public/users/passwords" },
                          :path_names => { :sign_in => "login", :sign_out => "logout" }


      # Public :: Pages
      #----------------------------------------------------------------------------
      resources :pages, :only => [:index, :show, :sitemap]
      match '/sitemap.xml' => 'pages#sitemap', :format => :xml


      # Public :: Pages :: Redirects
      #----------------------------------------------------------------------------
      match "/get_involved/shelters_and_rescues", :to => redirect("/shelters_and_rescues")

      match '*path' => 'pages#show'
      root :to => 'pages#index'
    end

  end

  #--------------------------------------------------------------------------------------------------------------------------------------------------------


  # Catch All - If route isn't found then Four oh Four
  #----------------------------------------------------------------------------
  match "*path", :to => redirect("/404.html")

end


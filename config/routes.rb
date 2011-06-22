ShelterExchangeApp::Application.routes.draw do
  
  

  # Admin - Routes for manage.domain.com
  #----------------------------------------------------------------------------
  constraints(AdminSubdomain) do
        
    namespace :admin do
      match "/dashboard", :to => 'dashboard#index'
    end
    
    devise_for :owners, :path => "admin", :controllers => { :sessions => "admin/owners/sessions" },
                        :path_names => { :sign_in => "login", :sign_out => "logout" }
    
    
    root :to => redirect("/admin/dashboard")
    
  end
  
  
  
  
  # Application - Routes for *subdomain*.domain.com
  #----------------------------------------------------------------------------
  constraints(AppSubdomain) do

    # Notes
    #----------------------------------------------------------------------------
    resources :notes, :only => [:create, :edit, :update, :destroy]

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
        get :status_by_current_month
        get :type_by_current_month
        get :adoptions_monthly_total
        get :adoptions_monthly_total_by_type
        get :euthanized_monthly_total
        get :euthanized_monthly_total_by_type
        get :intake_monthly_total
        get :intake_monthly_total_by_type
        get :foster_care_monthly_total
        get :foster_care_monthly_total_by_type
        get :reclaimed_monthly_total
        get :reclaimed_monthly_total_by_type
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
    
    # Placements
    #----------------------------------------------------------------------------
    resources :placements, :only => [:create, :edit, :update, :destroy] do
      resources :comments
    end
 
    # Communities
    #----------------------------------------------------------------------------    
    resources :communities do
      collection do
        get :search_by_city_zipcode
        get :search_by_shelter_name
        get :filter_notes
        get :find_animals_in_bounds
        get :find_animals_for_shelter
      end
      # member do
      #   get :animal
      # end
    end
    match 'communities/animal/:animal_id' => 'communities#animal', :as => :animal_communities

    # Maps
    #----------------------------------------------------------------------------
    resources :maps, :only => [:overlay]
    
    # Transfers
    #----------------------------------------------------------------------------
    resources :transfers, :except => [:index, :show]
    
    # Parents
    #----------------------------------------------------------------------------
    resources :parents do
      resources :notes
      collection do
        get :search
        get :find_animals_by_name
      end
    end
    
    # Animals
    #----------------------------------------------------------------------------
    resources :animals do
      resources :notes
      resources :alerts 
      resources :tasks 
      collection do
        get :search
        get :filter_notes
        get :filter_by_type_status
        get :auto_complete
      end
    end
      
    # Breeds
    #----------------------------------------------------------------------------
    resources :breeds, :only => [:auto_complete] do
      get :auto_complete, :on => :collection
    end

    # Shelters
    #----------------------------------------------------------------------------
    resources :shelters, :only => [:index, :edit, :update, :auto_complete] do
      get :auto_complete, :on => :collection
    end 

    # Wish Lists
    #----------------------------------------------------------------------------    
    resources :wish_lists, :only => [:edit, :update]
    
    # Capacities
    #----------------------------------------------------------------------------
    resources :capacities
    
    # API
    #----------------------------------------------------------------------------
    resources :api, :only => [:animals]
    match '/api/:version/animals' => 'api#animals'
        
    # Account Settings
    #----------------------------------------------------------------------------
    resources :settings, :only => [:index] 
    resources :token_authentications, :only => [:create, :destroy]
    
    # Users
    #----------------------------------------------------------------------------
    resources :users, :except => [:show, :new, :create] do
      member do
        post :change_password
        post :change_owner
      end
    end

    devise_for :users, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :confirmation => "confirmation", :invitation => "invitation" } 

    # Dashboard
    #----------------------------------------------------------------------------
    match "/dashboard", :to => 'dashboard#index'
    
    # ROOT
    #----------------------------------------------------------------------------
    root :to => redirect("/dashboard")
    
  end
  

# REMOVE LATER - Public Website Routes for www.domain.com
  constraints(PublicSubdomain) do
    
#   Public Route
    resources :public
    # , :path => "" do
    #   collection do
    #     get :videos
    #   end
    # end
    
#   Public - Pages
    get "videos" => "public#videos", :path => :videos
    
#   Accounts Route
    resources :accounts
    get "signup" => "accounts#new", :path => :signup
    post "signup" => "accounts#create", :path => :signup
    
    
    root :to => "public#index"
  end


  # Catch All - If route isn't found then Four oh Four
  #----------------------------------------------------------------------------
  match "*path" => redirect("/404.html")   
  
end

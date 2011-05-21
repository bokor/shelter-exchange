Shelterexchange::Application.routes.draw do

# Application Website Routes for *subdomain*.domain.com
  constraints(AppSubdomain) do

#   Notes Routes
    resources :notes, :only => [:create, :edit, :update, :destroy]

#   Comments Routes
    resources :comments, :only => [:create, :edit, :update, :destroy]

#   Items Routes    
    resources :items

#   Reports Routes    
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
    
#   Locations Routes 
    resources :locations, :only => [:create, :edit, :update, :destroy] do
      collection do
        get :find_all
      end
    end

#   Accommodations Routes 
    resources :accommodations, :except => [:show] do
      collection do
        get :search
        get :filter_by_type_location
      end
    end
    
#   Tasks Routes
    resources :tasks, :except => [:show] do
      post :completed, :on => :member
    end

#   Alerts Routes
    resources :alerts, :except => [:show] do
      post :stopped, :on => :member
    end
    
#   Placements Routes
    resources :placements, :only => [:create, :edit, :update, :destroy] do
      resources :comments
    end
    
    resources :communities do
      collection do
        get :search_by_city_zipcode
        get :search_by_shelter_name
        get :filter_notes
        get :find_animals_in_bounds
        get :find_animals_for_shelter
      end
    end
    match 'communities/animal/:animal_id' => 'communities#animal', :as => :animal_communities

#   Maps Routes      
    resources :maps 
    
#   Transfers Routes    
    resources :transfers, :except => [:index, :show] do
      member do
        post :approved
        post :completed
      end
    end
    
#   Parents Routes
    resources :parents do
      resources :notes
      collection do
        get :search
        get :find_animals_by_name
      end
    end
    
#   Animals Routes
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
    
    resources :photos, :only => [:destroy]
    resources :logos, :only => [:destroy]
    
#   Breeds Routes - Used as a look up for the auto_complete on the animal page
    resources :breeds, :only => [:auto_complete] do
      get :auto_complete, :on => :collection
    end

#   Shelter Routes 
    resources :shelters, :only => [:index, :edit, :update, :auto_complete] do
      get :auto_complete, :on => :collection
    end 
    
    resources :wish_lists, :only => [:edit, :update]
    
#   Capacity Routes    
    resources :capacities
    
#   API Routes   
    resources :api, :only => [:animals]
    match '/api/:version/animals' => 'api#animals'
        
#   Account Settings Routes    
    resources :settings, :only => [:index] 
    resources :token_authentications, :only => [:create, :destroy]
    
#   Users Routes - Localized updated
    resources :users, :except => [:show, :new, :create] do
      member do
        post :change_password
        post :change_owner
      end
    end

#   Devise Routes
    devise_for :users, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :confirmation => "confirmation", :invitation => "invitation" } 

#   Dashboard Routes   
    match "/dashboard", :to => 'dashboard#index'
    
#   Root Route - will redirect to animals as the first page
    # root :to => redirect("/animals")
    root :to => redirect("/dashboard")
    
  end
  
  constraints(AdminSubdomain) do
    # NEED TO TRY MIGHT NOT WORK
    #devise_for :admins, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :confirmation => "confirmation", :invitation => "invite" } 
    namespace :admin do
      scope "admin", :as => "" do
        
      end
    end
  end 
  

# Public Website Routes for www.domain.com
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


# 404 Error for URLs not mapped  
  match "*path" => redirect("/404.html")   
end

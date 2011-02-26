Shelterexchange::Application.routes.draw do


# Application Website Routes for *subdomain*.domain.com
  constraints(AppSubdomain) do

#   Notes Routes
    resources :notes

#   Comments Routes
    resources :comments

#   Items Routes    
    resources :items

#   Reports Routes    
    resources :reports do
      collection do
        get :status_by_current_year
        get :status_by_current_month
        get :type_by_current_year
        get :type_by_current_month
        get :adoption_monthly_total
        get :adoption_monthly_total_by_type
        get :euthanasia_monthly_total
        get :euthanasia_monthly_total_by_type
        get :intake_monthly_total
        get :intake_monthly_total_by_type
      end
    end
    
#   Locations Routes 
    resources :locations

#   Accommodations Routes 
    resources :accommodations do
      collection do
        get :full_search
        get :filter_by_type_location
      end
    end
    
#   Tasks Routes
    resources :tasks do
      get :completed, :on => :member
    end

#   Alerts Routes
    resources :alerts do
      get :stopped, :on => :member
    end
    
#   Placements Routes
    resources :placements do
      resources :comments
    end
    
#   Parents Routes
    resources :parents do
      resources :notes
      collection do
        get :search
        get :search_animal_by_name
      end
    end
    
#   Animals Routes
    resources :animals do
      resources :notes
      resources :alerts 
      resources :tasks 
      collection do
        get :full_search
        get :search_by_name
        get :filter_notes
        get :filter_by_type_status
        get :auto_complete
      end
    end
    
#   Breeds Routes - Used as a look up for the auto_complete on the animal page
    resources :breeds do
      get :auto_complete,  :on => :collection
    end

#   Shelter Routes 
    resources :shelters 
    
#   Capacity Routes    
    resources :capacities

#   Accounts Routes    
    # resources :accounts
#   API Routes   
    resources :api, :only => [:animals]
    match '/api/:version/animals' => 'api#animals'
        
#   Account Settings Routes    
    resources :settings 
    resources :token_authentications, :only => [:create, :destroy]
    
#   Users Routes - Localized updated
    resources :users do
      member do
        post :change_password
        post :change_owner
      end
    end

#   Devise Routes
    devise_for :users, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :confirmation => "confirmation", :invitation => "invitation" } 
    
#   Root Route - will redirect to animals as the first page
    root :to => redirect("/animals")
    
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

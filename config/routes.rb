Shelterexchange::Application.routes.draw do

# Application Website Routes for *subdomain*.domain.com
  constraints(AppSubdomain) do

#   Notes Routes
    resources :notes
    
#   Tasks Routes
    resources :tasks do
      get :completed, :on => :member
    end

#   Alerts Routes
    resources :alerts do
      get :stopped, :on => :member
    end

#   Reports Routes    
    resources :reports
    
#   Placements Routes
    resources :placements
    
#   Parents Routes
    resources :parents do
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
        get :auto_complete
        get :find_by
        get :live_search
      end
    end
    
#   Breeds Routes - Used as a look up for the auto_complete on the animal page
    resources :breeds do
      get :auto_complete,  :on => :collection
    end

#   Shelter Routes 
    resources :shelters

#   Users Routes - Localized updated
    resources :users

#   Devise Routes
    # devise_for :users 
     
    devise_for :users, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout" } 
    match "login" => "devise/sessions#new", :path => :new_user_session #used to be :as
    match "logout" => "devise/sessions#destroy", :path => :destroy_user_session
    
#   Root Route - will redirect to animals as the first page
    root :to => redirect("/animals")
  end
  

# Public Website Routes for www.domain.com
  constraints(PublicSubdomain) do
    
#   Public Route
    resources :public
    
#   Accounts Route
    resources :accounts
    get "signup" => "Accounts#new", :path => :signup
    post "signup" => "Accounts#create", :path => :signup
    
#   Public - Pages
    match "videos" => "Public#videos", :path => :videos
    
    root :to => "Public#index"
  end


# 404 Error for URLs not mapped  
  match "*path" => redirect("/404.html")   
  
  
  
  
  # root :to => "public#index"
  
  # resources :apis do
  #     collection do
  #       get "animals"
  #     end
  #   end
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

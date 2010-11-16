Shelterexchange::Application.routes.draw do
  constraints(ApplicationSubdomain) do
    resources :notes
    resources :tasks do
      get :completed, :on => :member
    end
    resources :alerts do
      get :stopped, :on => :member
    end
    resources :reports
  
    resources :animals do
      resources :notes
      resources :alerts 
      resources :tasks 
      collection do
        get :find_by
        get :live_search
      end
    end
  
    resources :breeds do
      get :auto_complete,  :on => :collection
    end
  
    resources :shelters
    resources :users
    resources :user_sessions
    resources :profile, :controller => :users
  
  
    match 'register' => "Users#new", :as => :register
    get   'login' => 'UserSessions#new', :as => :login
    post  'login'  => 'UserSessions#create', :as => :login
    match 'logout' => "UserSessions#destroy", :as => :logout
  
  
    root :to => redirect('/animals')
  end
  
  constraints(PublicSubdomain) do
    resources :public
    resources :accounts
    
    get 'signup' => "Accounts#new", :as => :signup
    post 'signup' => "Accounts#create", :as => :signup
    
    root :to => "public#index"
    # TODO - Handle 404 ERRORS better
    match "*path" => redirect("/404.html") 
  end
  
  
  
  
  
  
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

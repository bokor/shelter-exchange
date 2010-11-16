module SubdomainUsers
  def self.included(controller)
    controller.helper_method(:current_user, :current_user_session, :require_user, :require_no_user,  :redirect_back_or_default, 
                             :created_by_current_user?, :created_by_user?,:current_user?,:account_owner?)
  end
  
  protected
    
    def current_user?(user)
      current_user.id == user.id
    end
    
    def created_by_current_user?(object)
      object.user_id == current_user.id.to_s
    end
    
    def created_by_user?(object, user)
      object.user_id == user.id
    end

    def account_owner?
      current_user && current_user.id == @current_account.owner_id
    end
    
    def require_account_owner
      unless current_user && current_user.id == @current_account.owner_id
        store_location
        flash[:notice] = "You must be an account owner to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def owned_by_current_user?(object)
      object.user_id == current_user.id.to_s
    end

    def current_user
      @current_user ||= current_user_session && current_user_session.record
    end

    def current_user_session
      @current_user_session ||= @current_account != nil ? @current_account.user_sessions.find : nil
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end    
    # def current_user?(user)
    #   current_user.id == user.id
    # end
    # 
    # def created_by_current_user?(object)
    #   object.user_id == current_user.id.to_s
    # end
    # 
    # def created_by_user?(object, user)
    #   object.user_id == user.id
    # end
    # 
    # def account_owner?
    #   current_user && current_user.id == @current_account.owner_id
    # end
    # 
    # def require_account_owner
    #   unless current_user && current_user.id == @current_account.owner_id
    #     store_location
    #     flash[:notice] = "You must be an account owner to access this page"
    #     redirect_to account_url
    #     return false
    #   end
    # end
    # 
    # def require_user
    #   unless current_user
    #     store_location
    #     flash[:notice] = "You must be logged in to access this page"
    #     redirect_to new_user_session_url
    #     return false
    #   end
    # end
    # 
    # def require_no_user
    #   if current_user
    #     store_location
    #     flash[:notice] = "You must be logged out to access this page"
    #     redirect_to account_url
    #     return false
    #   end
    # end
    # 
    # def owned_by_current_user?(object)
    #   object.user_id == current_user.id.to_s
    # end
    # 
    # def current_user
    #   @current_user ||= current_user_session && current_user_session.record
    # end
    # 
    # def current_user_session
    #   @current_user_session ||= @current_account != nil ? @current_account.user_sessions.find : nil
    # end
    # 
    # def store_location
    #   session[:return_to] = request.request_uri
    # end
    # 
    # def redirect_back_or_default(default)
    #   redirect_to(session[:return_to] || default)
    #   session[:return_to] = nil
    # end
    
end
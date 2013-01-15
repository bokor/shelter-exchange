class Admin::Owners::SessionsController < ::Devise::SessionsController

  layout 'admin/login'
  
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
      when :owner, Owner
        session[:"owner_return_to"].blank? ? admin_dashboard_index_path.to_s : session[:"owner_return_to"].to_s 
      else
        super
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
      when :owner, Owner
        new_owner_session_path
      else
        super
    end
  end
end
class Public::Users::PasswordsController < ::Devise::PasswordsController
  layout 'public/application'
  
  
  private
  
    def resource_name
      :user
    end
  
end
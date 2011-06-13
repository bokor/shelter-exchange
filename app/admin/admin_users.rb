ActiveAdmin.register AdminUser, :as => "Admin" do
  
  filter :name
  filter :email
  filter :created_at
  
  index do
    #id_column, :sortable => false
    column :name
    column :email
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end
  
  show :title => :name do 
    attributes_table_for admin_user, :name, :email, :created_at
  end
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :email #, :label => "Publish Post At"
      # f.input :password
      # f.input :password_confirmation
    end
    f.buttons
  end

  
  after_create { |admin| admin.send_reset_password_instructions }
  def password_required?
    new_record? ? false : super
  end
    
end

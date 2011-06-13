ActiveAdmin.register AdminUser do
  
  filter :name
  filter :email
  filter :created_at
  
  index do
    # id_column, :sortable => false
    column :name
    column :email
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end
  
  show :title => :name do 
    panel "Admin User Details" do
      attributes_table_for admin_user, :id, :name, :email, :sign_in_count, :created_at, :last_sign_in_at
    end

  end
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
  end
    
end
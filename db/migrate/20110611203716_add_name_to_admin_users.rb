class AddNameToAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :name, :string
  end

  def self.down
  end
end

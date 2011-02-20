class AddFirstLastNameToUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
  end

  def self.down
  end
end

class RenameNameColumnUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :first_name, :name
    remove_column :users, :last_name
  end

  def self.down
  end
end

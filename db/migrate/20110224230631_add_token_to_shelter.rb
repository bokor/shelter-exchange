class AddTokenToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :access_token, :string
    add_index :shelters, :access_token, :unique => true
  end

  def self.down
    remove_column :shelters, :access_token
    remove_index :shelters, :access_token
  end
end

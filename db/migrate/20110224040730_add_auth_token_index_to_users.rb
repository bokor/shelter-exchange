class AddAuthTokenIndexToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :authentication_token, :unique => true
  end

  def self.down
    remove_index :users, :authentication_token
  end
end

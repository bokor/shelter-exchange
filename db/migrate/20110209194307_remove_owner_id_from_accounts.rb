class RemoveOwnerIdFromAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :owner_id
  end

  def self.down
  end
end

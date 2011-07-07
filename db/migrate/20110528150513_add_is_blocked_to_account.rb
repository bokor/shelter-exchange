class AddIsBlockedToAccount < ActiveRecord::Migration
  def self.up
    # remove_column :accounts, :approved
    add_column :accounts, :is_blocked, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :is_blocked
  end
end

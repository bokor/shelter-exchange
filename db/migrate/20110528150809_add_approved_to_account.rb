class AddApprovedToAccount < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :is_blocked
    add_column :accounts, :approved, :boolean, :default => true
  end

  def self.down
    remove_column :accounts, :approved
  end
end

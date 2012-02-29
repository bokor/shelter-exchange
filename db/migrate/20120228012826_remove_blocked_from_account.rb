class RemoveBlockedFromAccount < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :blocked
    remove_column :accounts, :reason_blocked
  end

  def self.down
  end
end

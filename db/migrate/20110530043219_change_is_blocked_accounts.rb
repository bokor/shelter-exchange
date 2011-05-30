class ChangeIsBlockedAccounts < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :is_blocked, :blocked
  end

  def self.down
  end
end

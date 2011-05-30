class ChangeReasonBlockedAccount < ActiveRecord::Migration
  def self.up
    change_column :accounts, :reason_blocked, :text
  end

  def self.down
  end
end

class AddReasonToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :reason_blocked, :string
  end

  def self.down
  end
end

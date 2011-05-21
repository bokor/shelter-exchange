class RemoveStatusFromTransfer < ActiveRecord::Migration
  def self.up
    remove_column :transfers, :status
  end

  def self.down
  end
end

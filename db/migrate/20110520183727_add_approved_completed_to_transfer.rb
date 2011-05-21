class AddApprovedCompletedToTransfer < ActiveRecord::Migration
  def self.up
    add_column :transfers, :approved, :boolean, :default => false
    add_column :transfers, :completed, :boolean, :default => false
  end

  def self.down
  end
end

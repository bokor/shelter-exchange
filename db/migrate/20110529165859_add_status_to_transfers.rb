class AddStatusToTransfers < ActiveRecord::Migration
  def self.up
    remove_column :transfers, :approved
    remove_column :transfers, :completed
    add_column :transfers, :status, :string
  end

  def self.down
  end
end

class RemoveApprovedAndAddStatusTransfers < ActiveRecord::Migration
  def self.up
    remove_column :transfers, :approved
    add_column :transfers, :status, :string
  end

  def self.down
  end
end

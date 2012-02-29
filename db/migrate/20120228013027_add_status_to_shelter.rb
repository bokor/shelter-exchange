class AddStatusToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :status, :string, :default => :active
    add_column :shelters, :status_reason, :text
  end

  def self.down
    remove_column :shelters, :status
    remove_column :shelters, :status_reason
  end
end

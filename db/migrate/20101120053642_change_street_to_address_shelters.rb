class ChangeStreetToAddressShelters < ActiveRecord::Migration
  def self.up
    rename_column :shelters, :street, :address
  end

  def self.down
  end
end

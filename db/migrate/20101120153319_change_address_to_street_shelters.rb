class ChangeAddressToStreetShelters < ActiveRecord::Migration
  def self.up
    rename_column :shelters, :address, :street
  end

  def self.down
  end
end

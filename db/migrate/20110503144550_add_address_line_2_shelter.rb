class AddAddressLine2Shelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :street_2, :string
  end

  def self.down
    remove_column :shelters, :street_2
  end
end

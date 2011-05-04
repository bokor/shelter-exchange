class AddAddressLine2Parent < ActiveRecord::Migration
  def self.up
    add_column :parents, :street_2, :string
  end

  def self.down
    remove_column :parents, :street_2
  end
end

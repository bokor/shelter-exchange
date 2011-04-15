class ChangeStreetParentsShelters < ActiveRecord::Migration
  def self.up
    change_column :parents, :street, :string
    change_column :shelters, :street, :string
  end

  def self.down
  end
end

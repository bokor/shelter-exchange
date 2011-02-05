class AddFacebookToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :facebook, :string
  end

  def self.down
    remove_column :shelters, :facebook
  end
end

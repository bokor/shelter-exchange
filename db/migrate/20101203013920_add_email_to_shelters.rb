class AddEmailToShelters < ActiveRecord::Migration
  def self.up
    add_column :shelters, :email, :string
  end

  def self.down
    remove_column :shelters, :email
  end
end

class AddShelterToComments < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.references :shelter
    end
    add_index(:comments, :shelter_id)
  end

  def self.down
     remove_column :comments, :shelters
     remove_index :comments, :column => :shelter_id
  end
end

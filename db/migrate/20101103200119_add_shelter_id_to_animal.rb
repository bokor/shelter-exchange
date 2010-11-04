class AddShelterIdToAnimal < ActiveRecord::Migration
  def self.up
    change_table :animals do |t|
        t.references :shelter
      end
    add_index(:animals, :shelter_id)
  end

  def self.down
     remove_column :animals, :shelters
     remove_index :animals, :column => :shelter_id
  end
end

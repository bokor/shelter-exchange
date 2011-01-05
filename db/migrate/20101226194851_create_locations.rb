class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.references :shelter
      t.references :animal_type
      t.string :name
      t.integer :max_capacity
      
      t.timestamps
    end
    add_index(:locations, :shelter_id)
    add_index(:locations, :animal_type_id)
  end

  def self.down
    drop_table :locations
  end
end

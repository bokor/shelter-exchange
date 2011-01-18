class CreateAccommodations < ActiveRecord::Migration
  def self.up
    create_table :accommodations do |t|
      t.references :shelter
      t.references :animal_type
      t.string :name
      t.integer :max_capacity
      
      t.timestamps
    end
    add_index(:accommodations, :shelter_id)
    add_index(:accommodations, :animal_type_id)
  end

  def self.down
    drop_table :accommodations
  end
end

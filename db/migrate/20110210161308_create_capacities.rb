class CreateCapacities < ActiveRecord::Migration
  def self.up
    create_table :capacities do |t|
      t.references :shelter
      t.references :animal_type
      t.integer :max
      t.timestamps
    end
    add_index(:capacities, :shelter_id)
    add_index(:capacities, :animal_type_id)
    add_index(:capacities, [:shelter_id, :animal_type_id])
  end

  def self.down
    drop_table :capacities
    remove_index :capacities, :column => :shelter_id
    remove_index :capacities, :column => :animal_type_id
    remove_index :capacities, :column => [:shelter_id, :animal_type_id]
  end
end
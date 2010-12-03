class CreatePlacements < ActiveRecord::Migration
  def self.up
    drop_table :parent_histories
    create_table :placements do |t|
      t.references :animal
      t.references :parent
      t.references :shelter
      t.string :placement_type
      t.text :comment
      t.timestamps
    end
    add_index(:placements, :animal_id)
    add_index(:placements, :parent_id)
    add_index(:placements, :shelter_id)
    add_index(:placements, [:parent_id, :placement_type])
  end

  def self.down
    drop_table :placements
    remove_index :placements, :column => :animal_id
    remove_index :placements, :column => :parent_id
    remove_index :placements, :column => :shelter_id
    remove_index :placements, :column => [:parent_id, :placement_type]
  end
end

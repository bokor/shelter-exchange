class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.references :shelter
      t.timestamps
    end
    add_index(:locations, :shelter_id)
  end

  def self.down
    drop_table :locations
    remove_index :locations, :shelter_id
  end

end

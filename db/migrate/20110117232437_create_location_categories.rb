class CreateLocationCategories < ActiveRecord::Migration
  def self.up
    create_table :location_categories do |t|
      t.string :name
      t.references :shelter
      t.timestamps
    end
    add_index(:location_categories, :shelter_id)
  end

  def self.down
    drop_table :location_categories
    remove_index :location_categories, :shelter_id
  end
end

class AddLocationToAnimal < ActiveRecord::Migration
  def self.up
    change_table :animals do |t|
      t.references :location
    end
    add_index(:animals, :location_id)
  end

  def self.down
     remove_column :animals, :location
     remove_index :animals, :column => :location_id
  end

end

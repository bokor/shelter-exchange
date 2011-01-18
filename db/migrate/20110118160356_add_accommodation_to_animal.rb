class AddAccommodationToAnimal < ActiveRecord::Migration
  def self.up
    change_table :animals do |t|
      t.references :accommodation
    end
    add_index(:animals, :accommodation_id)
  end

  def self.down
     remove_column :animals, :accommodation_id
     remove_index :animals, :column => :accommodation_id
  end

end

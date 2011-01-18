class AddLocationToAccommodation < ActiveRecord::Migration
  def self.up
    change_table :accommodations do |t|
      t.references :location
    end
    add_index(:accommodations, :location_id)
  end

  def self.down
     remove_column :accommodations, :location_id
     remove_index :accommodations, :column => :location_id
  end

end

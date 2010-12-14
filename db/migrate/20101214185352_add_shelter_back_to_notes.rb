class AddShelterBackToNotes < ActiveRecord::Migration
  def self.up
    change_table :notes do |t|
      t.references :shelter
    end
    add_index(:notes, :shelter_id)
  end

  def self.down
     remove_column :notes, :shelters
     remove_index :notes, :column => :shelter_id
  end
end

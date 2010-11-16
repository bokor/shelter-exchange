class AddShelterToAlerts < ActiveRecord::Migration
  def self.up
    change_table :alerts do |t|
      t.references :shelter
    end
    add_index(:alerts, :shelter_id)
  end

  def self.down
     remove_column :alerts, :shelters
     remove_index :alerts, :column => :shelter_id
  end
end

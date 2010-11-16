class AddShelterToTasks < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.references :shelter
    end
    add_index(:tasks, :shelter_id)
  end

  def self.down
     remove_column :tasks, :shelters
     remove_index :tasks, :column => :shelter_id
  end
end

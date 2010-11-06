class CreateAnimalStatuses < ActiveRecord::Migration
  def self.up
    create_table :animal_statuses do |t|
      t.string :name
      
      t.timestamps
    end
    add_index(:animal_statuses, :name)
    add_index(:animal_statuses, :created_at)
  end

  def self.down
    drop_table :animal_statuses
    remove_index :animal_statuses, :column => :name
    remove_index :animal_statuses, :column => :created_at
  end
end

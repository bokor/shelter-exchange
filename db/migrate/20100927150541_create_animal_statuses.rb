class CreateAnimalStatuses < ActiveRecord::Migration
  def self.up
    create_table :animal_statuses do |t|
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :animal_statuses
  end
end

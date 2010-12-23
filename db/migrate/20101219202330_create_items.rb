class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.references :shelter
      t.string :name
      
      t.timestamps
    end
    
    add_index(:items, :shelter_id)
  end

  def self.down
    drop_table :items
    remove_index :items, :column => :shelter_id
  end
end

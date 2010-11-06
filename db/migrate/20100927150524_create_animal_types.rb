class CreateAnimalTypes < ActiveRecord::Migration
  def self.up
    create_table :animal_types do |t|
      t.string :name

      t.timestamps
    end
    add_index(:animal_types, :name)
    add_index(:animal_types, :created_at)
  end

  def self.down
    drop_table :animal_types
    remove_index :animal_types, :column => :name
    remove_index :animal_types, :column => :created_at
  end
end

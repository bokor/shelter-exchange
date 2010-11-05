class CreateAnimalTypes < ActiveRecord::Migration
  def self.up
    create_table :animal_types do |t|
      t.string :name

      t.timestamps
    end
    add_index(:animal_types, :name)
  end

  def self.down
    drop_table :animal_types
    remove_index :animal_types, :column => :name
  end
end

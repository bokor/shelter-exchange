class CreateAnimalTypes < ActiveRecord::Migration
  def self.up
    create_table :animal_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :animal_types
  end
end

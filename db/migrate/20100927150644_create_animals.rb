class CreateAnimals < ActiveRecord::Migration
  def self.up
    create_table :animals do |t|
      t.string :chip_id
      t.string :name
      t.text :description
      t.string :sex
      t.string :weight
      t.string :age
      t.boolean :is_sterilized
      t.string :color
      t.boolean :is_mix_breed
      t.string :primary_breed
      t.string :secondary_breed
      t.references :animal_type #, :foreign_key => true, :null => false
      t.references :animal_status #, :foreign_key => true, :null => false
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
    add_index(:animals, :animal_type_id)
    add_index(:animals, :animal_status_id)
    add_index(:animals, :name)
    add_index(:animals, :description)
    add_index(:animals, [:id, :name, :description, :chip_id, :color, :primary_breed, :secondary_breed])
  end

  def self.down
    drop_table :animals
    remove_index :animals, :column => :animal_type_id
    remove_index :animals, :column => :animal_status_id
    remove_index :animals, :column => :name
    remove_index :animals, :column => :description
    remove_index :animals, :column => [:id, :name, :description, :chip_id, :color, :primary_breed, :secondary_breed]
  end
end
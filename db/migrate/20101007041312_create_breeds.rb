class CreateBreeds < ActiveRecord::Migration
  def self.up
    create_table :breeds do |t|
      t.string :name
      t.references :animal_type

      t.timestamps
    end
    add_index(:breeds, :animal_type_id)
    add_index(:breeds, :name)
    add_index(:breeds, :created_at)
  end

  def self.down
    drop_table :breeds
    remove_index :breeds, :column => :animal_type_id
    remove_index :breeds, :column => :name
    remove_index :breeds, :column => :created_at
  end
end

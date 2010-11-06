class CreateNoteCategories < ActiveRecord::Migration
  def self.up
    create_table :note_categories do |t|
      t.string :name

      t.timestamps
    end
    add_index(:note_categories, :name)
    add_index(:note_categories, :created_at)
  end

  def self.down
    drop_table :note_categories
    remove_index :note_categories, :column => :name
    remove_index :note_categories, :column => :created_at
  end
end

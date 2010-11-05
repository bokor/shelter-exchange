class CreateNoteCategories < ActiveRecord::Migration
  def self.up
    create_table :note_categories do |t|
      t.string :name

      t.timestamps
    end
    add_index(:note_categories, :name)
  end

  def self.down
    drop_table :note_categories
    remove_index :note_categories, :column => :name
  end
end

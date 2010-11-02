class CreateNoteCategories < ActiveRecord::Migration
  def self.up
    create_table :note_categories do |t|
      t.string :name
      # t.string :subject_type #typeof item note attached too (example Animal)

      t.timestamps
    end
    # add_index(:note_categories, :subject_type)
  end

  def self.down
    drop_table :note_categories
    # remove_index :note_categories, :column => :subject_type
  end
end

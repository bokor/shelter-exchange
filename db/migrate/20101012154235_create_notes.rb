class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string :title
      t.text :description
      t.references :subject, :polymorphic => true
      t.references :note_category #, :foreign_key => true, :null => false

      t.timestamps
    end
    add_index(:notes, :subject_id)
    add_index(:notes, :subject_type)
    add_index(:notes, :note_category_id)
    add_index(:notes, :title)
    add_index(:notes, :description)
  end

  def self.down
    drop_table :notes
    remove_index :notes, :column => :subject_id
    remove_index :notes, :column => :subject_type
    remove_index :notes, :column => :note_category_id
    remove_index :notes, :column => :title
    remove_index :notes, :column => :description
  end
end

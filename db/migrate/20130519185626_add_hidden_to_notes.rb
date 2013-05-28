class AddHiddenToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :hidden, :boolean, :default => false
    add_index :notes, :hidden
  end
end

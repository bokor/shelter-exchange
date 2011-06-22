class ChangeNoteCategoriesNote < ActiveRecord::Migration
  def self.up
    remove_column :notes, :note_category_id
    add_column :notes, :category, :string
  end

  def self.down
  end
end

class RemoveNoteCategoryTable < ActiveRecord::Migration
  def self.up
    drop_table :note_categories
  end

  def self.down
  end
end

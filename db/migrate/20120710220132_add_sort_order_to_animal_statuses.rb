class AddSortOrderToAnimalStatuses < ActiveRecord::Migration
  def self.up
    add_column :animal_statuses, :sort_order, :integer
    add_index :animal_statuses, :sort_order
  end

  def self.down
    remove_column :animal_statuses, :sort_order
  end
end

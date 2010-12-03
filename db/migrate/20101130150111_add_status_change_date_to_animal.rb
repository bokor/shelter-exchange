class AddStatusChangeDateToAnimal < ActiveRecord::Migration
  def self.up
    add_column :animals, :status_change_date, :date
    add_index(:animals, :status_change_date)
  end

  def self.down
    remove_column :animals, :status_change_date
    remove_index :animals, :column => :status_change_date
  end
end

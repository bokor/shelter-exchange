class AddKillShelterDetailsToAnimals < ActiveRecord::Migration
  def self.up
    add_column :animals, :arrival_date, :date
    add_column :animals, :hold_time, :integer
    add_column :animals, :euthanasia_date, :date
  end

  def self.down
    remove_column :animals, :arrival_date
    remove_column :animals, :hold_time
    remove_column :animals, :euthanasia_date
  end
end

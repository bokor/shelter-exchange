class ChangeAgeToDateFieldAnimals < ActiveRecord::Migration
  def self.up
    rename_column :animals, :age, :date_of_birth
    change_column :animals, :date_of_birth, :date
  end

  def self.down
  end
end

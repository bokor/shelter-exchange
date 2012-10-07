class AddAgeToAnimals < ActiveRecord::Migration
  def self.up
    add_column :animals, :age, :string
  end

  def self.down
  end

end
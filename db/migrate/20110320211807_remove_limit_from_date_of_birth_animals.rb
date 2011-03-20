class RemoveLimitFromDateOfBirthAnimals < ActiveRecord::Migration
  def self.up
    change_column :animals, :date_of_birth, :date, :limit => nil
  end

  def self.down
  end
end

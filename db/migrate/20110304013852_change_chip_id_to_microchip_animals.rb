class ChangeChipIdToMicrochipAnimals < ActiveRecord::Migration
  def self.up
    rename_column :animals, :chip_id, :microchip
  end

  def self.down
  end
end

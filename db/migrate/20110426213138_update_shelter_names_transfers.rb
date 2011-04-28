class UpdateShelterNamesTransfers < ActiveRecord::Migration
  def self.up
    rename_column :transfers, :from_shelter, :from_shelter_id
    rename_column :transfers, :to_shelter, :to_shelter_id
  end

  def self.down
  end
end

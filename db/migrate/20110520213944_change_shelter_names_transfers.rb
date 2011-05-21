class ChangeShelterNamesTransfers < ActiveRecord::Migration
  def self.up
    rename_column :transfers, :to_shelter_id, :requestor_shelter_id
    rename_column :transfers, :from_shelter_id, :shelter_id
  end

  def self.down
  end
end

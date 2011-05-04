class ChangeOrganizationNameToNameShelter < ActiveRecord::Migration
  def self.up
    rename_column :shelters, :organization_name, :name
  end

  def self.down
  end
end

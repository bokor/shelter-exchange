class RenameShelterName < ActiveRecord::Migration
  def self.up
    rename_column :shelters, :name, :organization_name
  end

  def self.down
  end
end

class RemoveShelterFromNotes < ActiveRecord::Migration
  def self.up
    remove_column :notes, :shelter_id
  end

  def self.down
  end
end

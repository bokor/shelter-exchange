class AddTimeZoneToShelter < ActiveRecord::Migration
  def self.up
    add_column :shelters, :time_zone, :string
  end

  def self.down
    remove_column :shelters, :time_zone
  end
end

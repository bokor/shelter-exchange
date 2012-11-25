class UpdateLatLngShelterGeocoder < ActiveRecord::Migration
  def up
    rename_column :shelters, :lat, :latitude
    rename_column :shelters, :lng, :longitude
    change_column :shelters, :latitude, :float
    change_column :shelters, :longitude, :float
  end

  def down
    rename_column :shelters, :latitude, :lat
    rename_column :shelters, :longitude, :lng
    change_column :shelters, :lat, :decimal, {:precision => 15, :scale => 10 }
    change_column :shelters, :lng, :decimal, {:precision => 15, :scale => 10 }
  end
end

class AddLatLngPhotoToContact < ActiveRecord::Migration
  def change
    add_column :contacts,  :lat, :decimal, {:precision => 15, :scale => 10 }
    add_column :contacts,  :lng, :decimal, {:precision => 15, :scale => 10 }
    add_index  :contacts, [:lat, :lng]

    add_column :contacts, :photo, :string
  end
end

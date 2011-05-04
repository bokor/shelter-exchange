class ChangePhoneFaxFields < ActiveRecord::Migration
  def self.up
    rename_column :shelters, :main_phone, :phone
    rename_column :shelters, :fax_phone, :fax
  end

  def self.down
  end
end

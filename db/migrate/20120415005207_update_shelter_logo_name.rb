class UpdateShelterLogoName < ActiveRecord::Migration
  def self.up
      rename_column :shelters, :logo_file_name, :logo
      remove_column :shelters, :logo_content_type
      remove_column :shelters, :logo_file_size
      remove_column :shelters, :logo_updated_at
  end

  def self.down
  end

end

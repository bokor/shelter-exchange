class UpdateAccountDocumentName < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :document_file_name, :document
    remove_column :accounts, :document_content_type
    remove_column :accounts, :document_file_size
    remove_column :accounts, :document_updated_at
  end

  def self.down
  end
end

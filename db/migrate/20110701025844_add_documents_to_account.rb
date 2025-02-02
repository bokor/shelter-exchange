class AddDocumentsToAccount < ActiveRecord::Migration
  def self.up
      add_column :accounts, :document_file_name,    :string
      add_column :accounts, :document_content_type, :string
      add_column :accounts, :document_file_size,    :integer
      add_column :accounts, :document_updated_at,   :datetime
    end

    def self.down
      remove_column :accounts, :document_file_name
      remove_column :accounts, :document_content_type
      remove_column :accounts, :document_file_size
      remove_column :accounts, :document_updated_at
    end
end

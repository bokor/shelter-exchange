class ChangeDocumentStatusToTypeAccounts < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :document_status, :document_type
  end

  def self.down
  end
end

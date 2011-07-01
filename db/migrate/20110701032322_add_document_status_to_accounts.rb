class AddDocumentStatusToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :document_status, :string
  end

  def self.down
  end
end

class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :document
      t.string :original_name
      t.references :attachable, :polymorphic => true
      t.timestamps
    end
    add_index :documents, :attachable_id
    add_index :documents, :attachable_type
    add_index :documents, [:attachable_id, :attachable_type]
  end

  def self.down
    drop_table :documents
  end
end

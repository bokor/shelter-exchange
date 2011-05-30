class CreateTransferHistories < ActiveRecord::Migration
  def self.up
    create_table :transfer_histories do |t|
      t.references :shelter
      t.references :transfer
      t.string :status
      t.text :reason
      t.timestamps
    end
    add_index :transfer_histories, :shelter_id
    add_index :transfer_histories, :transfer_id
  end

  def self.down
    drop_table :transfer_histories
    remove_index :transfer_histories, :column => :shelter_id
    remove_index :transfer_histories, :column => :transfer_id
  end
end


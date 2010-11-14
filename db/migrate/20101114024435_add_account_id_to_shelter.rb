class AddAccountIdToShelter < ActiveRecord::Migration
  def self.up
    change_table :shelters do |t|
      t.references :account
    end
    add_index(:shelters, :account_id)
  end

  def self.down
     remove_column :shelters, :account_id
     remove_index :shelters, :column => :account_id
  end
end

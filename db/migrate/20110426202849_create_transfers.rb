class CreateTransfers < ActiveRecord::Migration
  def self.up
    create_table :transfers do |t|
      t.references :animal
      t.integer :to_shelter
      t.boolean :approved, :default => false
      t.string :requestor
      t.string :phone
      t.string :email
      t.timestamps
    end
    add_index :transfers, :animal_id
  end

  def self.down
    drop_table :transfers
    remove_index :transfers, :column => :animal_id
  end
end
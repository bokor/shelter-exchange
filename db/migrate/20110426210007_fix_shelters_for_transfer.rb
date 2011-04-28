class FixSheltersForTransfer < ActiveRecord::Migration
  def self.up
    add_column :transfers, :from_shelter, :integer
    add_index :transfers, :to_shelter
    add_index :transfers, :from_shelter
  end

  def self.down
  end
end

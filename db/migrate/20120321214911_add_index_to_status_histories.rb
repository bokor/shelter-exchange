class AddIndexToStatusHistories < ActiveRecord::Migration
  def self.up
    add_index :status_histories, [:created_at, :animal_id]
  end

  def self.down
    remove_index :status_histories, :column => [:created_at, :animal_id]
  end
end

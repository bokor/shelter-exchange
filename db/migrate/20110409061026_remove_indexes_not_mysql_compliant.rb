class RemoveIndexesNotMysqlCompliant < ActiveRecord::Migration
  def self.up
    # remove_index :alerts, [:description]
    # remove_index :animals, [:description]
    # remove_index :notes, [:description]
  end

  def self.down
  end
end

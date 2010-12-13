class RenameInfoToDetailsTasks < ActiveRecord::Migration
  def self.up
    rename_column :tasks, :info, :details
  end

  def self.down
  end
end

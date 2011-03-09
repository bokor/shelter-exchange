class ChangeWarningLevelToInt < ActiveRecord::Migration
  def self.up
    change_column :capacities, :warning_level, :integer
  end

  def self.down
  end
end

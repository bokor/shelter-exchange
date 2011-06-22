class ChangeEuthanasiaScheduledAnimal < ActiveRecord::Migration
  def self.up
    rename_column :animals, :euthanasia_scheduled, :euthanasia_date
  end

  def self.down
  end
end

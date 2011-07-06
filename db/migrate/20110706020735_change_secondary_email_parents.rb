class ChangeSecondaryEmailParents < ActiveRecord::Migration
  def self.up
    rename_column :parents, :email_2, :email_2
  end

  def self.down
  end
end

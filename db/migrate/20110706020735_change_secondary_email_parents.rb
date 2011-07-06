class ChangeSecondaryEmailParents < ActiveRecord::Migration
  def self.up
    rename_column :parents, :secondary_email, :email_2
  end

  def self.down
  end
end

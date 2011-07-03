class AddSecondaryEmailAddressToParent < ActiveRecord::Migration
  def self.up
    add_column :parents, :secondary_email, :string
  end

  def self.down
    remove_column :parents, :secondary_email
  end
end

class AddSecondaryEmailAddressToParent < ActiveRecord::Migration
  def self.up
    add_column :parents, :email_2, :string
  end

  def self.down
    remove_column :parents, :email_2
  end
end

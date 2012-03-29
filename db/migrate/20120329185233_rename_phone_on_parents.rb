class RenamePhoneOnParents < ActiveRecord::Migration
  def self.up
    rename_column :parents, :home_phone, :phone
    rename_column :parents, :mobile_phone, :mobile
    remove_index :parents, :name => :full_search
    add_index(:parents, [:phone, :mobile, :email, :email_2], :name => :full_search)
  end

  def self.down
  end
end

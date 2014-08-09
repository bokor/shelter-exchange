class ChangeParentNameToFirstAndLast < ActiveRecord::Migration
  def change
    rename_column :parents, :name, :first_name
    add_column :parents, :last_name, :string
  end
end


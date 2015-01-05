class AddAddtionalInfoToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :additional_info, :text
  end
end

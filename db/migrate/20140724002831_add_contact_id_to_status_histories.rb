class AddContactIdToStatusHistories < ActiveRecord::Migration
  def change
    add_column :status_histories, :contact_id, :integer
    add_index :status_histories, :contact_id
    add_index :status_histories, [:contact_id, :animal_status_id]
  end
end

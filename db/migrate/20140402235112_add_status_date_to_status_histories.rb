class AddStatusDateToStatusHistories < ActiveRecord::Migration
  def change
    add_column :status_histories, :status_date, :date
    add_index :status_histories, :status_date
    add_index :status_histories, [:status_date, :created_at]
  end
end

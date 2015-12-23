class DropTransfers < ActiveRecord::Migration
  def change
    drop_table :transfer_histories
    drop_table :transfers
  end
end

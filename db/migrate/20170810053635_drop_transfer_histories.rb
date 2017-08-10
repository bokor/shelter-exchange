class DropTransferHistories < ActiveRecord::Migration
  def change
    drop_table :transfer_histories
  end
end

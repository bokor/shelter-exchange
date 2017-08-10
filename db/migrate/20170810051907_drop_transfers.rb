class DropTransfers < ActiveRecord::Migration
  def change
    drop_table :transfers
  end
end

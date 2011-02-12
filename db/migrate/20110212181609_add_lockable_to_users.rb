class AddLockableToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
       t.lockable
     end
  end

  def self.down
  end
end
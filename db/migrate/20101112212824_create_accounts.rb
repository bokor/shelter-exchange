class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.string :subdomain, :unique => true

      t.timestamps
    end
    add_index :accounts, :subdomain
  end

  def self.down
    drop_table :accounts
    remove_index :accounts, :column =>  :subdomain
  end
end

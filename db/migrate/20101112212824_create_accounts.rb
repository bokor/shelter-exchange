class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.string :subdomain

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

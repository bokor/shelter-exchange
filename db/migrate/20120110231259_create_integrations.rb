class CreateIntegrations < ActiveRecord::Migration
  def self.up
    create_table :integrations do |t|
      t.string :type
      t.string :username
      t.string :password
      t.references :shelter
      
      t.timestamps
    end
    add_index :integrations, :shelter_id
    add_index :integrations, [:id, :type]
    add_index :integrations, :type
  end

  def self.down
    # remove_index :integrations, :column => :shelter_id
    #  remove_index :integrations, :column => [:id, :type]
    drop_table :integrations
  end
end

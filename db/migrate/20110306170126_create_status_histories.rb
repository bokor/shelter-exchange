class CreateStatusHistories < ActiveRecord::Migration
  def self.up
    create_table :status_histories do |t|
      t.references :shelter
      t.references :animal
      t.references :animal_status
      t.string :reason
      t.timestamps
    end
    add_index :status_histories, :shelter_id
    add_index :status_histories, :animal_id
    add_index :status_histories, :animal_status_id
  end

  def self.down
    drop_table :status_histories
    add_index :status_histories, :column => :shelter_id
    add_index :status_histories, :column => :animal_id
    add_index :status_histories, :column => :animal_status_id
  end
end
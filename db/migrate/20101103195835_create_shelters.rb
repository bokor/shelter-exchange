class CreateShelters < ActiveRecord::Migration
  def self.up
    create_table :shelters do |t|
      t.string :name
      t.string :main_phone
      t.string :fax_phone
      t.string :website
      t.string :twitter
      t.text :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.timestamps
    end
    # add_index(:shelters, :created_at)
  end

  def self.down
    drop_table :shelters
    # remove_index :shelters, :column => :created_at
  end
end

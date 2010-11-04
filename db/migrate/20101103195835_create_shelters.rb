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
  end

  def self.down
    drop_table :shelters
  end
end

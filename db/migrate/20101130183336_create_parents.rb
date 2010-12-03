class CreateParents < ActiveRecord::Migration
  def self.up
    create_table :parents do |t|
      t.string :name
      t.text :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :home_phone
      t.string :mobile_phone
      t.string :email
      t.timestamps
    end
    add_index(:parents, [:name, :street, :home_phone, :mobile_phone, :email])
  end

  def self.down
    drop_table :parents
    remove_index :parents, :column => [:name, :street, :home_phone, :mobile_phone, :email]
  end
end

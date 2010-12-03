class AddShelterToParentHistory < ActiveRecord::Migration
  def self.up
    change_table :parent_histories do |t|
      t.references :shelter
    end
    add_index(:parent_histories, :shelter_id)
  end

  def self.down
     remove_column :parent_histories, :shelters
     remove_index :parent_histories, :column => :shelter_id
  end
end

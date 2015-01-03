class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :shelter_id
      t.integer :animal_type_id
      t.string :adoption_contract
      t.string :boilerplate_description
      t.timestamps
    end

    add_index :settings, :shelter_id
    add_index :settings, :animal_type_id
  end
end


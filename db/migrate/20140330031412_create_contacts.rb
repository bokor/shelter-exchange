class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :street
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone
      t.string :mobile
      t.string :email
      t.boolean :adopter
      t.boolean :foster
      t.boolean :volunteer
      t.boolean :transporter
      t.boolean :donor
      t.boolean :staff
      t.boolean :vet
      t.boolean :other
      t.string :other_name
      t.integer :shelter_id
      t.timestamps
    end

    add_index :contacts, :shelter_id
  end
end


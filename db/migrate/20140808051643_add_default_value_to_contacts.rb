class AddDefaultValueToContacts < ActiveRecord::Migration
  def change
    change_column :contacts, :adopter, :boolean, :default => false
    change_column :contacts, :foster, :boolean, :default => false
    change_column :contacts, :volunteer, :boolean, :default => false
    change_column :contacts, :transporter, :boolean, :default => false
    change_column :contacts, :donor, :boolean, :default => false
    change_column :contacts, :staff, :boolean, :default => false
    change_column :contacts, :veterinarian, :boolean, :default => false
  end
end

class AddCompanyAndTitleToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :company_name, :string
    add_column :contacts, :job_title, :string
    add_index :contacts, :email
    add_index :contacts, [:phone, :mobile]
    add_index :contacts, [:last_name, :first_name, :company_name]
  end
end

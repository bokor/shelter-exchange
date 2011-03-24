class AddMissingIndexesToAllTables < ActiveRecord::Migration
  def self.up
    add_index(:accommodations, :name)
    add_index(:comments, :created_at)
    add_index(:locations, :name)
    add_index(:parents, :created_at)
    add_index(:parents, [:home_phone, :mobile_phone, :email], :name => :full_search)
    add_index(:placements, [:parent_id, :shelter_id, :animal_id])
    add_index(:tasks, :updated_at)
    add_index(:tasks, [:updated_at, :due_date])
    add_index(:breeds, [:animal_type_id, :name])
    add_index(:animals, [:animal_type_id, :animal_status_id, :name], :name => :auto_complete)
    add_index(:animals, [:animal_type_id, :animal_status_id, :id, :name], :name => :search_by_name)
   # add_index(:animals, [:animal_type_id, :animal_status_id, :id, :name, :description, :chip_id , :color, :age, :weight, :primary_breed, :secondary_breed], :name => :full_search)
  end

  def self.down
    remove_index :accommodations, :name
    remove_index :comments, :created_at
    remove_index :locations, :name
    remove_index :parents, :created_at
    remove_index :parents, [:home_phone, :mobile_phone, :email], :name => :full_search
    remove_index :placements, [:parent_id, :shelter_id, :animal_id]
    remove_index :tasks, :updated_at
    remove_index :tasks, [:updated_at, :due_date]
    remove_index :breeds, [:animal_type_id, :name]
    remove_index :animals, [:animal_type_id, :animal_status_id, :name], :name => :auto_complete
    remove_index :animals, [:animal_type_id, :animal_status_id, :id, :name], :name => :search_by_name
  #  remove_index :animals, [:animal_type_id, :animal_status_id, :id, :name, :description, :chip_id , :color, :age, :weight, :primary_breed, :secondary_breed], :name => :full_search
  end
end

 
class CreateParentHistories < ActiveRecord::Migration
  def self.up
    create_table :parent_histories do |t|
      t.references :animal
      t.references :parent
      t.string :type
      t.text :comment
      t.timestamps
    end
    add_index(:parent_histories, :animal_id)
    add_index(:parent_histories, :parent_id)
    add_index(:parent_histories, [:parent_id, :placement_type])
  end

  def self.down
    drop_table :parent_histories
    remove_index :parent_histories, :column => :animal_id
    remove_index :parent_histories, :column => :parent_id
    remove_index :parent_histories, :column => [:parent_id, :placement_type]
  end
end

class CreateComments < ActiveRecord::Migration
  def self.up
     create_table :comments do |t|
        t.text :comment
        t.references :commentable, :polymorphic => true

        t.timestamps
      end
      add_index(:comments, :commentable_id)
      add_index(:comments, :commentable_type)
      add_index(:comments, [:commentable_id, :commentable_type])
  end

  def self.down
    drop_table :comments
    remove_index :comments, :column => :commentable_id
    remove_index :comments, :column => :commentable_type
    remove_index :comments, :column => [:commentable_id, :commentable_type]
  end
end

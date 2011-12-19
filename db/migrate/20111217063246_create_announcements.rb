class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.string :title
      t.text :message
      t.string :category
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
    add_index :announcements, [:starts_at, :ends_at]
    add_index :announcements, [:starts_at, :ends_at, :updated_at]
    add_index :announcements, [:starts_at, :updated_at]
  end

  def self.down
    drop_table :announcements
    remove_index :announcements, :column => [:starts_at, :ends_at]
    remove_index :announcements, :column => [:starts_at, :ends_at, :updated_at]
    remove_index :announcements, :column => [:starts_at, :updated_at]
  end
end

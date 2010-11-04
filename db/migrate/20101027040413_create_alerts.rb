class CreateAlerts < ActiveRecord::Migration
  def self.up
    create_table :alerts do |t|
      t.string :title
      t.text :description
      t.references :subject, :polymorphic => true
      t.references :alert_type

      t.timestamps
    end
    add_index(:alerts, :subject_id)
    add_index(:alerts, :title)
    add_index(:alerts, :description)
  end

  def self.down
    drop_table :alerts
    remove_index :alerts, :column => :subject_id
    remove_index :alerts, :column => :title
    remove_index :alerts, :column => :description
  end
end

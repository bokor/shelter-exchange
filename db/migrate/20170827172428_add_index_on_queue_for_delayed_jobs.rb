class AddIndexOnQueueForDelayedJobs < ActiveRecord::Migration
  def self.up
    add_index :delayed_jobs, [:queue]
  end

  def self.down
    remove_index :delayed_jobs, :column => [:queue]
  end
end

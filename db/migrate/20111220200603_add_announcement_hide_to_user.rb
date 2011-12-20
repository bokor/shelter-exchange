class AddAnnouncementHideToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :announcement_hide_time, :datetime
  end

  def self.down
    remove_column :users, :announcement_hide_time
  end
end

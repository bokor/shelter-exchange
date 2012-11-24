class AddInvitationAcceptedAtUser < ActiveRecord::Migration
  def up
    add_column :users, :invitation_accepted_at, :datetime
  end

  def down
    remove_column :users, :invitation_accepted_at
  end
end

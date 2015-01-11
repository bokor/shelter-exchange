class ChangeUserInvitationTokenSize < ActiveRecord::Migration
  def change
    change_column :users, :invitation_token, :string, :limit => nil
  end
end

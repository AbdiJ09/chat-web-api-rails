class RemoveJoinedAtFromChatroomsUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :chatrooms_users, :joined_at, :timestamp
  end
end

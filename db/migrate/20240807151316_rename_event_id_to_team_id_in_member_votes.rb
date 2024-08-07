class RenameEventIdToTeamIdInMemberVotes < ActiveRecord::Migration[7.1]
  def change

    remove_foreign_key :member_votes, :events
    remove_index :member_votes, :event_id
    rename_column :member_votes, :event_id, :team_id
    add_foreign_key :member_votes, :teams
    add_index :member_votes, :team_id
  end
end

class AddColoumToTeamMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :team_members, :event_id, :integer
    add_foreign_key :team_members, :events, column: :event_id
  end
end

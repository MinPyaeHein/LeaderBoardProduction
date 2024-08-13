class AddColumnNameToTeamMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :team_members, :name, :string
    add_column :team_members, :bio, :string

  end
end

class AddColumnRoleToTeamMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :team_members, :role, :string
  end
end

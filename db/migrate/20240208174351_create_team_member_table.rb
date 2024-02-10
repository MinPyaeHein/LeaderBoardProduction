class CreateTeamMemberTable < ActiveRecord::Migration[7.1]
  def change
    create_table :team_members do |t|
      t.bigint :member_id
      t.bigint :team_id
      t.boolean :leader
      t.boolean :active
      t.timestamps
    end
    add_foreign_key :team_members, :members, column: :member_id
    add_foreign_key :team_members, :teams, column: :team_id
  end
end

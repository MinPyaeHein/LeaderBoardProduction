class CreateTableTeamEvent < ActiveRecord::Migration[7.1]
  def change
    create_table :team_events do |t|
      t.integer :team_id
      t.integer :event_id
      t.float :total_score
      t.timestamps
    end
    add_foreign_key :team_events, :teams, column: :team_id
    add_foreign_key :team_events, :events, column: :event_id
  end
end

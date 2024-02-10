class AddColoumInTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :event_id, :integer
    add_column :teams, :total_score, :float
    add_foreign_key :teams, :events, column: :event_id
  end
 
end

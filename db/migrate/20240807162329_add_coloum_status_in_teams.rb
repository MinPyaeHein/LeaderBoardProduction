class AddColoumStatusInTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :status, :integer, null: false, default: 2
    Team.update_all(status: 2)
  end
end

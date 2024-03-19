class AddPitchingOrderInTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :pitching_order, :integer, default: 1
  end
end

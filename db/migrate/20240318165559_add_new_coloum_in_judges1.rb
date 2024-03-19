class AddNewColoumInJudges1 < ActiveRecord::Migration[7.1]
  def change
    add_column :judges, :type, :integer, default: 1
  end
end

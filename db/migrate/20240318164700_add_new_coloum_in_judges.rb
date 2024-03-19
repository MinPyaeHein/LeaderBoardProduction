class AddNewColoumInJudges < ActiveRecord::Migration[7.1]
  def change
    add_column :judges, :type, :integer
  end
end

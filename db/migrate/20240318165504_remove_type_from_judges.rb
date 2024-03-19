class RemoveTypeFromJudges < ActiveRecord::Migration[7.1]
  def change
    remove_column :judges, :type, :integer
  end
end

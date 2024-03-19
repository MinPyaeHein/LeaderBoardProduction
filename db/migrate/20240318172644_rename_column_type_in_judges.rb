class RenameColumnTypeInJudges < ActiveRecord::Migration[7.1]
  def change
    rename_column :judges, :type, :judge_type
  end
end

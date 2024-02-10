class ChangeJudgeTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :judges, :faculty_id
  end
end

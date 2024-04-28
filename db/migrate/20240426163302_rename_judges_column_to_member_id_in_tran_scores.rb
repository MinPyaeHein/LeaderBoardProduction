class RenameJudgesColumnToMemberIdInTranScores < ActiveRecord::Migration[7.1]
  def change
    rename_column :tran_scores, :judge_id, :member_id
  end
end

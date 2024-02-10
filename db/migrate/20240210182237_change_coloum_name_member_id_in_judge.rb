class ChangeColoumNameMemberIdInJudge < ActiveRecord::Migration[7.1]
  def change
    rename_column :judges, :judge_id, :member_id
  end
end

class RemoveMemberIdFromTranScores < ActiveRecord::Migration[7.1]
  def change
    remove_column :tran_scores, :member_id
  end
end

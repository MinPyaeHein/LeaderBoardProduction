class AddJudgeIdToTranInvestor < ActiveRecord::Migration[7.1]
  def change
    add_column :tran_investors, :judge_id, :bigint
    add_foreign_key :tran_investors, :judges, column: :judge_id
  end
end

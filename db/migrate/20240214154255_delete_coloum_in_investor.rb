class DeleteColoumInInvestor < ActiveRecord::Migration[7.1]
  def change
    remove_column :score_matrices, :one_time_pay
    remove_column :score_matrices, :judge_acc_amount
  end
end

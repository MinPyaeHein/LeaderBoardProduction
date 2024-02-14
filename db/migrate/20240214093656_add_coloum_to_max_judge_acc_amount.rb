class AddColoumToMaxJudgeAccAmount < ActiveRecord::Migration[7.1]
  def change
    add_column :score_matrices, :judge_acc_amount, :float
  end
end

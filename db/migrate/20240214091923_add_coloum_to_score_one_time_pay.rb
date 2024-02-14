class AddColoumToScoreOneTimePay < ActiveRecord::Migration[7.1]
  def change
    add_column :score_matrices, :one_time_pay, :float
  end
end

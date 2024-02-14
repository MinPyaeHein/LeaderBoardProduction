class AddColoumToScoreMatrixp < ActiveRecord::Migration[7.1]
  def change
    add_column :score_matrices, :one_itme_pay, :float
  end
end

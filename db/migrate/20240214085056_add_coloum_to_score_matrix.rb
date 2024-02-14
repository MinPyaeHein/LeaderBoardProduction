class AddColoumToScoreMatrix < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :one_itme_pay, :float
  end
end

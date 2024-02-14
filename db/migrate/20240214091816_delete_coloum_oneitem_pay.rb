class DeleteColoumOneitemPay < ActiveRecord::Migration[7.1]
  def change
    remove_column :score_matrices, :one_itme_pay
  end
end

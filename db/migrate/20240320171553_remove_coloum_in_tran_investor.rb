class RemoveColoumInTranInvestor < ActiveRecord::Migration[7.1]
  def change
    remove_column :tran_investors, :investor_matrix_id, :int
  end
end

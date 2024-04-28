class DropTableTranScore < ActiveRecord::Migration[7.1]
  def change
    drop_table :tran_scores
  end
end

class DeleteColoumInScoreMax < ActiveRecord::Migration[7.1]
  def change
    remove_column :score_matrices, :double
  end
end

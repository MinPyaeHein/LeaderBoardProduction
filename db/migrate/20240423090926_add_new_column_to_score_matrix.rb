class AddNewColumnToScoreMatrix < ActiveRecord::Migration[7.1]
  def change
    add_column :score_matrices, :name, :string
  end
end

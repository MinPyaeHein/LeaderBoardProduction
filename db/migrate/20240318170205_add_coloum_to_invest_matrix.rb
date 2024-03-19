class AddColoumToInvestMatrix < ActiveRecord::Migration[7.1]
  def change
    add_column :investor_matrices, :type, :integer, default: 1
  end
end

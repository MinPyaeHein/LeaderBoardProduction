class RenameColumnInvestorMetrix < ActiveRecord::Migration[7.1]
  def change
    rename_column :investor_matrices, :type, :investor_type, default: 1
  end
end

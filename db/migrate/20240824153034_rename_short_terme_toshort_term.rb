class RenameShortTermeToshortTerm < ActiveRecord::Migration[7.1]
  def change
    rename_column :score_infos, :shortTerm, :short_term
  end
end

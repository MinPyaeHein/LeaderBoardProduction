class AddColumnNameToScoreInfo < ActiveRecord::Migration[7.1]
  def change
    add_column :score_infos, :shortTerm, :string
  end
end

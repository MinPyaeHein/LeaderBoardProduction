class ChangeColoumNameInJudge < ActiveRecord::Migration[7.1]
  def change
    rename_column :judges, :current_ammount, :current_amount
  end
end

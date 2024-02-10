class AddColoumToJudge < ActiveRecord::Migration[7.1]
  def change
    add_column :judges, :active, :boolean
  end
end

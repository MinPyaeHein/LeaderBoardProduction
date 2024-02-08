class AddScoreTypeTpEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :score_type_id, :integer
    add_foreign_key :events, :score_types, column: :score_type_id
  end
end

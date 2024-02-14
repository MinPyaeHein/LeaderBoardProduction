class CreateTableScoreMatrix < ActiveRecord::Migration[7.1]
  def change
    create_table :score_matrices do |t|
      t.float :weight
      t.float :max
      t.float :min
      t.float :double
      t.bigint :event_id
      t.bigint :score_info_id
      t.timestamps
    end
    add_foreign_key :score_matrices, :events, column: :event_id
    add_foreign_key :score_matrices, :score_infos, column: :score_info_id
  end
end

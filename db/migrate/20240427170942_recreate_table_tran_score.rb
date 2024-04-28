class RecreateTableTranScore < ActiveRecord::Migration[7.1]
  def change
    create_table :tran_scores do |t|
      t.float :score
      t.string :desc
      t.bigint :score_matrix_id
      t.bigint :team_event_id
      t.bigint :event_id
      t.bigint :judge_id
      t.timestamps
    end
    add_foreign_key :tran_scores, :judges, column: :judge_id
    add_foreign_key :tran_scores, :events, column: :event_id
    add_foreign_key :tran_scores, :team_events, column: :team_event_id
    add_foreign_key :tran_scores, :score_matrices, column: :score_matrix_id
  end
end

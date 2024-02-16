class CreateTableName < ActiveRecord::Migration[7.1]
  def change
    create_table :tran_investors do |t|
      t.float :amount
      t.string :desc
      t.bigint :team_event_id
      t.bigint :investor_matrix_id
      t.bigint :event_id
      t.timestamps
    end
    add_foreign_key :tran_investors, :investor_matrices, column: :investor_matrix_id
    add_foreign_key :tran_investors, :events, column: :event_id
    add_foreign_key :tran_investors, :team_events, column: :team_event_id



  end
end

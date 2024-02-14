class CreateTableInvestorMatrix < ActiveRecord::Migration[7.1]
  def change
    create_table :investor_matrices do |t|
      t.float :total_amount
      t.float :one_time_pay
      t.integer :event_id
      t.float :judge_acc_amount
      t.timestamps
    end
    add_foreign_key :investor_matrices, :events, column: :event_id
  end
end

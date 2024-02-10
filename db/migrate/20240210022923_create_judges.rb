class CreateJudges < ActiveRecord::Migration[7.1]
  def change
    create_table :judges do |t|
      t.integer :judge_id
      t.integer :event_id
      t.integer :current_ammount,default: 0
      t.timestamps
    end
    add_foreign_key :judges, :members, column: :judge_id
    add_foreign_key :judges, :events, column: :event_id
  end
end

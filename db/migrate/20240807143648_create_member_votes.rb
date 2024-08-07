class CreateMemberVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :member_votes do |t|
      t.references :member, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :status

      t.timestamps
    end
    add_index :member_votes, [:member_id, :event_id], unique: true
  end
end

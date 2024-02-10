class CreateAddEditorTable < ActiveRecord::Migration[7.1]
  def change
    create_table :editors do |t|
      t.bigint :member_id
      t.bigint :event_id
      t.boolean :active
      t.timestamps
    end
    add_foreign_key :editors, :members, column: :member_id
    add_foreign_key :editors, :events, column: :event_id
  end
end

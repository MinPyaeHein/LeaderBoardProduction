class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :desc
      t.boolean :active
      t.string :website_link
      t.bigint :organizer_id
      t.timestamps
    end
    add_foreign_key :teams, :members, column: :organizer_id
  end
end

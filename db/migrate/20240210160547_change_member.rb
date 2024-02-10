class ChangeMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :faculty_id, :integer
    add_foreign_key :members, :faculties, column: :faculty_id
  end
end

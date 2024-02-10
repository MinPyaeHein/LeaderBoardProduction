class AddColoumfacultyToJudge < ActiveRecord::Migration[7.1]
  def change
    add_column :judges, :faculty_id, :integer
    add_foreign_key :judges, :table_faculties, column: :faculty_id
  end
end

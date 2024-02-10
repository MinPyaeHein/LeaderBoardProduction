class TableFacultyToFaculties < ActiveRecord::Migration[7.1]
  def change
    rename_table :table_faculties, :faculties
  end
end

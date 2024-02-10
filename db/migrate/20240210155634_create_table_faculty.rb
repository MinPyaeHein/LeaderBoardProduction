class CreateTableFaculty < ActiveRecord::Migration[7.1]
  def change
    create_table :table_faculties do |t|
      t.string :name
      t.text :desc
      t.timestamps
    end
  end
end

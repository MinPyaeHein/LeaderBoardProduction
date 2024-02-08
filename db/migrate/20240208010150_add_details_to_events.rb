class AddDetailsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
    add_column :events, :all_day, :boolean
    add_column :events, :location, :string
    add_column :events, :organizer_id, :integer
    add_foreign_key :events, :members, column: :organizer_id
  end
end

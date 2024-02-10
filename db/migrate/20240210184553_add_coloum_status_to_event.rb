class AddColoumStatusToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :status, :integer
  end
end

class DropUsersTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :users
  end
end

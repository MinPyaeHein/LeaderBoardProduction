class AddColoumToMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :org_name, :string
    add_column :members, :profile_url, :string
  end
end

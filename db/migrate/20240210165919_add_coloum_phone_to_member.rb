class AddColoumPhoneToMember < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :phone, :string
  end
end

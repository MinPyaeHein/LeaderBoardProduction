class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.string :name
      t.boolean :active, default: true # Set a default value
      t.string :address
      t.text :desc
      t.timestamps
    end
  end
end

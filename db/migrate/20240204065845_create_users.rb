class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      
      t.string :email
      t.string :phone
      t.string :access_token
      t.string :password
      t.integer :role
      t.references :member, foreign_key: true
      t.timestamps

    end
  end
end

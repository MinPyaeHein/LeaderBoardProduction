class CreateScoreTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :score_types do |t|
      t.string :name
      t.text :desc
    

      t.timestamps
    end
  end
end

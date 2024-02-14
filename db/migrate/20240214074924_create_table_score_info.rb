class CreateTableScoreInfo < ActiveRecord::Migration[7.1]
  def change
    create_table :score_infos do |t|
      t.string :name
      t.string :desc
      t.timestamps
    end
    
  end
end

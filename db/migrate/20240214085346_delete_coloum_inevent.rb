class DeleteColoumInevent < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :one_itme_pay
  end
end

class RenameJudgesForeignKeyInTranScore < ActiveRecord::Migration[7.1]
  def change
    def change
      rename_foreign_key :tran_scores, :judges, :members, column: :member_id
    end

  end
end

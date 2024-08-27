class UpdateScoreMatrixForeignKeyToCascade < ActiveRecord::Migration[7.1]
  def change
        # Remove the existing foreign key constraint
        remove_foreign_key :score_matrices, :events

        # Add the new foreign key constraint with ON DELETE CASCADE
        add_foreign_key :score_matrices, :events, on_delete: :cascade

  end
end

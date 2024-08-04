class ScoreMatrixPolicy < ApplicationPolicy
  attr_reader :user, :score_matrix

  def initialize(user, score_matrix)
    @user = user
    @score_matrix = score_matrix
  end

  def create?
    user.present?
  end

  def get_all_team_score_categories_by_judge
    editor_or_owner?
  end

  private
  def editor_or_owner?
    user.present? && (event.owner_id == user.id || event.editors.exists?(user_id: user.id))
  end


end

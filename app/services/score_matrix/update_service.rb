class ScoreMatrix::UpdateService
  def initialize(score_matrices)
    @score_matrices = score_matrices
  end

  def updateScoreMatrices
    updated_matrices = @score_matrices.map do |score_matrix|
      updateScoreMatrix(score_matrix)
    end

    {
      success: updated_matrices.none? { |result| result[:errors].present? },
      message: updated_matrices
    }
  end

  private

  def updateScoreMatrix(score_matrix)
    existing_matrix = ::ScoreMatrix.find_by(id: score_matrix["id"])

    unless existing_matrix
      return { errors: ["Score Matrix with ID #{score_matrix['id']} not found."] }
    end

    total_weight = calculate_total_weight(score_matrix["event_id"], score_matrix["id"])
    if total_weight + score_matrix["weight"].to_f > 1
      return { errors: ["Total weight for the event exceeds 100%."] }
    end

    score_info = ::ScoreInfo.find_or_create_by(
      name: score_matrix["name"],
      short_term: score_matrix["shortTerm"]
    ) do |info|
      info.desc = score_matrix["desc"]
    end

    unless score_info.persisted?
      return { errors: score_info.errors.full_messages }
    end

    existing_matrix.assign_attributes(
      weight: score_matrix["weight"],
      min: score_matrix["min"],
      max: score_matrix["max"],
      event_id: score_matrix["event_id"],
      name: score_matrix["name"],
      score_info_id: score_info.id
    )

    if existing_matrix.save
      { scoreMatrix: existing_matrix, scoreInfo: score_info }
    else
      { errors: existing_matrix.errors.full_messages }
    end
  end

  def calculate_total_weight(event_id, exclude_id)
    ::ScoreMatrix.where(event_id: event_id).where.not(id: exclude_id).sum(:weight)
  end
end

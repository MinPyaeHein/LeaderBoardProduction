class ScoreMatrix::UpdateService
  def initialize(score_matrices)
    @score_matrices = score_matrices
  end

  def updateScoreMatrices
    return { errors: ["No score matrices provided."] } if @score_matrices.empty?

    event_id = @score_matrices.first["event_id"]

    # Step 1: Delete all existing score matrices for the event
    ::ScoreMatrix.where(event_id: event_id).destroy_all

    # Step 2: Create new score matrices
    created_matrices = @score_matrices.map do |score_matrix|
      createScoreMatrix(score_matrix)
    end

    {
      success: created_matrices.none? { |result| result[:errors].present? },
      message: created_matrices
    }
  end

  private

  def createScoreMatrix(score_matrix)
    total_weight = calculate_total_weight(score_matrix["event_id"])

    if total_weight + score_matrix["weight"].to_f > 1
      return { errors: ["Total weight for the event exceeds 100%."] }
    end

    score_info = ::ScoreInfo.find_or_create_by(
      name: score_matrix["name"],
      short_term: score_matrix["short_term"]
    ) do |info|
      info.desc = score_matrix["desc"]
    end

    unless score_info.persisted?
      return { errors: score_info.errors.full_messages }
    end

    new_matrix = ::ScoreMatrix.new(
      weight: score_matrix["weight"],
      min: score_matrix["min"],
      max: score_matrix["max"],
      event_id: score_matrix["event_id"],
      name: score_matrix["name"],
      score_info_id: score_info.id
    )

    if new_matrix.save
      { scoreMatrix: new_matrix, scoreInfo: score_info }
    else
      { errors: new_matrix.errors.full_messages }
    end
  end

  def calculate_total_weight(event_id)
    ::ScoreMatrix.where(event_id: event_id).sum(:weight)
  end
end

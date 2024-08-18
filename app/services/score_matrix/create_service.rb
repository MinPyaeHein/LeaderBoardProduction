class ScoreMatrix::CreateService
  def initialize(score_matrices)
    @score_matrices = score_matrices
  end

  def createScoreMatrices
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
    score_info = ::ScoreInfo.find_or_create_by(
      name: score_matrix["name"],
      shortTerm: score_matrix["shortTerm"]
    ) do |info|
      info.desc = score_matrix["desc"]
    end

    unless score_info.persisted?
      return { errors: score_info.errors.full_messages }
    end

    result = check_existing_score_matrix(score_matrix, score_info)

    if result[:errors].nil?
      new_score_matrix = ::ScoreMatrix.new(
        weight: score_matrix["weight"],
        min: score_matrix["min"],
        max: score_matrix["max"],
        event_id: score_matrix["event_id"],
        name: score_matrix["name"],
        score_info_id: score_info.id
      )

      if new_score_matrix.save
        { scoreMatrix: new_score_matrix, scoreInfo: score_info }
      else
        { errors: new_score_matrix.errors.full_messages }
      end
    else
      result
    end
  end

  def check_existing_score_matrix(score_matrix, score_info)
    existing_matrix = ::ScoreMatrix.find_by(
      event_id: score_matrix["event_id"],
      score_info_id: score_info.id
    )

    if existing_matrix
      { errors: ["This Score Matrix already exists in the event."] }
    else
      {}
    end
  end
end

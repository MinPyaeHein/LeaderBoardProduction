class TranScorePolicy < ApplicationPolicy
  def create?
    user.member.judges.any? { |judge| judge.event_id == record.event_id } && user.member.id==record.judge_id
  end

end

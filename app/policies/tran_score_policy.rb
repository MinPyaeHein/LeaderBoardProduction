class TranScorePolicy < ApplicationPolicy
  def create?
    user.member.judges.any? { |judge| judge.event_id == record.event_id }
  end

end

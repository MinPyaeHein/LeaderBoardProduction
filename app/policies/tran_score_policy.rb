class TranScorePolicy < ApplicationPolicy
  def create?
    # Assuming `record` is a TranScore instance and `user` is the current user
    user.member.judges.any? { |judge| judge.event_id == record.event_id } && user.member.id==record.judge_id
  end
  
end

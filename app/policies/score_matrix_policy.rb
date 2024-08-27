require_dependency 'concerns/policy_concern'
class ScoreMatrixPolicy < ApplicationPolicy
  include PolicyConcern
  def create?
    create_policy_authorization(record)
  end
  def update?
    @event=Event.find(record.event_id)
    puts("@event.approved?==",@event.approved?)
    (create_policy_authorization(record)||user.superAdmin?)&&@event.approved?
  end
end

require_dependency 'concerns/policy_concern'
class ScoreMatrixPolicy < ApplicationPolicy
  include PolicyConcern
  def create?
    create_policy_authorization(record)
  end
end

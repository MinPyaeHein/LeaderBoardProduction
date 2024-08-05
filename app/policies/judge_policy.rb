require_dependency 'concerns/policy_concern'
class JudgePolicy < ApplicationPolicy
  include InvestorMatrixPolicyConcern
  def create?
    create_policy_authorization(record)
  end
end

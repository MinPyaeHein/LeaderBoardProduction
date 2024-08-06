require_dependency 'concerns/policy_concern'
class TeamPolicy < ApplicationPolicy
  include PolicyConcern
  def create?
     create_policy
  end

  def create_team_with_leaders?
     create_policy
  end
  private
  def create_policy
    create_policy_authorization(record)
  end
end

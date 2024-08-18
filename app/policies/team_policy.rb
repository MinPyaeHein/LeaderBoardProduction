require_dependency 'concerns/policy_concern'
class TeamPolicy < ApplicationPolicy
  include PolicyConcern
  def create?
     create_policy
  end

  def update_status?
    team_update_policy
  end

  def create_team_with_leaders?
     create_policy
  end
  private
  def create_policy
    create_policy_authorization(record)
  end
  def team_update_policy
      @team=Team::find_by(id: record.id)
      return false unless @team
      puts("user.member==",user.member.id)
      authorized = user.member.events.any? do |event|
      puts("ordanized event event.id==", event.id)
      event.id == @team.event_id
      end
      puts("authorized==",authorized)
    @event = Event.find_by(id: @team.event_id)
    return false unless @event

    event_approved = @event.editors.present? &&
                     @event.editors.any? { |editor| editor.member_id == user.member.id }

    authorized || event_approved
  end
end

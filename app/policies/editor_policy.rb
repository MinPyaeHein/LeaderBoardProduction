class EditorPolicy < ApplicationPolicy
  def create?
    authorized = user.member.events.any? do |event|
      event.id == record.event_id
    end
    authorized
  end
end

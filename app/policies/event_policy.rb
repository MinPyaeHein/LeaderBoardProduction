class EventPolicy < ApplicationPolicy
  def update?

    authorized = user.member.events.any? do |event|
      event.id == record.id
    end

    @event = Event.find_by(id: record.id)
    return false unless @event
    event_approved = if @event.editors.nil?
      false
    else
      @event.editors.any? { |editor| editor.member_id == user.member.id }
    end
    authorized || event_approved
  end

  def update_status?
    # Allow if the user is a superAdmin
    return true if user.superAdmin?

    @event = Event.find_by(id: record.id)
    return false unless @event

    # Check if the user is an editor of the event
    event_approved = @event.editors&.any? { |editor| editor.member_id == user.member.id } || false

    # Allow if the user is authorized or if the event is approved
    user.role.present? || event_approved
  end

end

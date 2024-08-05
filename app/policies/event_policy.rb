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

    # Return true if the user is either authorized or an approved editor
    authorized || event_approved
  end
end

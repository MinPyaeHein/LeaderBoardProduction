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
    if(record.status=='approved')
      return true if user.superAdmin?
    else
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
      authorized || event_approved ||user.superAdmin?
    end
  end

end


module PolicyConcern
  extend ActiveSupport::Concern

  def create_policy_authorization(record)
    authorized = user.member.events.any? do |event|
      event.id == record.event_id
    end
    @event = Event.find_by(id: record.event_id)
    return false unless @event

    event_approved = @event.editors.present? &&
                     @event.editors.any? { |editor| editor.member_id == user.member.id }

    authorized || event_approved
  end
end

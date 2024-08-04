class UserPolicy < ApplicationPolicy
    def call_test?
      user.present?
    end

    def call_test_owner?
      user.present? && record.id == user.id
    end

    def editor_or_owner?(event_id)
      puts 'event_id=', event_id
      true
      # user.present? && (record.organizer_id == user.id || record.editors.exists?(user_id: user.id))
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end

end

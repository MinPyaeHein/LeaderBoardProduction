class Judge < ApplicationRecord
    enum judge_type: { judge: 1, student: 2}
    belongs_to :member, dependent: :destroy
    belongs_to :event, dependent: :destroy
end
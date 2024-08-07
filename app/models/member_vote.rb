class MemberVote < ApplicationRecord
    has_many :member, dependent: :destroy
    has_many :team, dependent: :destroy

end

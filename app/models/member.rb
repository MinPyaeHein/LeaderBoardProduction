class Member < ApplicationRecord
    has_many :team_members, dependent: :destroy
    has_many :teams, through: :team_members, dependent: :destroy
    has_many :users, dependent: :destroy
    has_many :judges, dependent: :destroy
    has_many :editors, dependent: :destroy
    has_many :events, foreign_key: 'organizer_id', dependent: :destroy
end

class Member < ApplicationRecord
    has_many :team_members
    has_many :teams, through: :team_members
    has_many :users
    has_many :judges
    has_many :judgeEvents, through: :judges 
    has_many :editors
    has_many :editorEvents, through: :editors
end

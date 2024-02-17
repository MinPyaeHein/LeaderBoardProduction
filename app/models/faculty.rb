class Faculty < ApplicationRecord
    has_many :members, dependent: :destroy
end
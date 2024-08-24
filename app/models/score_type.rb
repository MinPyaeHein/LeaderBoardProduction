class ScoreType < ApplicationRecord
  belongs_to :score_info, :dependent => :destroy
end

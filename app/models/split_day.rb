class SplitDay < ApplicationRecord
  belongs_to :split_plan
  has_many :workouts, dependent: :destroy
end

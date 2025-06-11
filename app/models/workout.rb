class Workout < ApplicationRecord
  has_many :workout_logs
  belongs_to :split_day
end

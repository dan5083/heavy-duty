class SplitPlan < ApplicationRecord
  belongs_to :user

  has_many :split_days, dependent: :destroy
end

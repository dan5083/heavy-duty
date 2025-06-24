class ClientAssignment < ApplicationRecord
  belongs_to :personal_trainer
  belongs_to :user

  validates :user_id, uniqueness: { scope: :personal_trainer_id }
end

class PersonalTrainer < ApplicationRecord
  belongs_to :user
  has_many :client_assignments, dependent: :destroy
  has_many :clients, through: :client_assignments, source: :user

  validates :name, presence: true

  def can_view_user?(target_user)
    target_user == user || clients.include?(target_user)
  end
end

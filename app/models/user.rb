class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # NEW: Virtual attribute for signup form
  attr_accessor :is_trainer

  # Existing relationships
  has_many :split_plans, dependent: :destroy
  has_many :workout_logs, dependent: :destroy

  # NEW: Trainer relationships
  has_one :personal_trainer, dependent: :destroy
  has_many :client_assignments, dependent: :destroy
  has_many :trainers, through: :client_assignments, source: :personal_trainer

  # NEW: Helper methods
  def trainer?
    personal_trainer.present?
  end

  def can_view_user?(target_user)
    self == target_user ||
    (trainer? && personal_trainer.clients.include?(target_user))
  end

  def primary_trainer
    trainers.first
  end

  # Auto-generate password for trainer-created clients
  def generate_temporary_password!
    temp_password = SecureRandom.alphanumeric(8)
    self.password = temp_password
    self.password_confirmation = temp_password
    temp_password
  end
end

class Task < ApplicationRecord
  validates :name, presence: true
  scope :completed, -> { where.not(completed_at: nil) }
end

class Enrollment < ApplicationRecord
  belongs_to :student, class_name: 'User', foreign_key: 'user_id'
  belongs_to :batch

  enum status: { pending: 0, approved: 1, rejected: 2, completed: 3 }

  scope :active, -> { where(status: [:pending, :approved]) }

  scope :with_batch, -> (batch) {
    where('batch_id' => batch.id)
  }

  validate :validate_unique_active_enrollment, on: :create

  def validate_unique_active_enrollment
    if student && student.enrollments.active.exists?
      errors.add(:base, "Student already has an active enrollment.")
    end
  end

  [:pending, :approved, :rejected, :completed].each do |method_name|
    define_method "#{method_name}?" do ||
      self.status == status
    end
  end

end

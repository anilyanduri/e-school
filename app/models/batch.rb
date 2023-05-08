class Batch < ApplicationRecord
  belongs_to :course
  belongs_to :school

  has_many :enrollments
  has_many :students, through: :enrollments, class_name: "User", foreign_key: "user_id"

  scope :with_course, -> (course) {
    where('course_id' => course.id)
  }

  scope :with_school, -> (school) {
    where('school_id' => school.id)
  }

end

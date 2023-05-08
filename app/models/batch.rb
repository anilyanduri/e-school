class Batch < ApplicationRecord
  belongs_to :course
  belongs_to :school


  scope :with_course, -> (course) {
    where('course_id' => course.id)
  }

  scope :with_school, -> (school) {
    where('school_id' => school.id)
  }

end

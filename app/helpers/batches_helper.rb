module BatchesHelper

  def get_icon(batch, student, color=nil)
    if enrolment = student.enrollments.with_batch(batch).first
        icon_from_string(enrolment.status, color)
    else
        icon_from_string('enroll', color)
    end
  end
end

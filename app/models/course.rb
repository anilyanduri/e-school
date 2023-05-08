class Course < ApplicationRecord
  belongs_to :school

  scope :school_id, -> (school_id) {
    where('school_id' => school_id)
  }

  def generate_material
    self.material = ""
    1000.to_i.times { self.material << SecureRandom.alphanumeric(rand(20)); self.material << ' '}
  end
end

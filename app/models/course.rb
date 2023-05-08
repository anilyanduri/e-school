class Course < ApplicationRecord
  belongs_to :school
  has_many :batches
  before_create :generate_material


  scope :with_school, -> (school) {
    where('school_id' => school.id)
  }

  private

  def generate_material
    if self.material.blank?
      self.material = ""
      1000.to_i.times do
        self.material << SecureRandom.alphanumeric(rand(20))
        self.material << ' '
      end
    end
  end
end

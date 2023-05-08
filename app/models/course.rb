class Course < ApplicationRecord
  belongs_to :school

  def generate_material
    self.material = ""
    1000.to_i.times { self.material << SecureRandom.alphanumeric(rand(20)); self.material << ' '}
  end
end

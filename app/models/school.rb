class School < ApplicationRecord

  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"

  validates_with IsCreatedByAdmin

  SCHOOL_STATUS.each do |method_name, status|
    define_method "#{method_name.downcase}?" do |*args|
      self.status == status
    end
  end


  def toogle_status
    self.status = self.active? ? DEACTIVATED : ACTIVE
  end

end

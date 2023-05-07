class IsCreatedByAdmin < ActiveModel::Validator
  def validate(record)
    unless record.created_by.has_role?(:admin)
      record.errors.add(:created_by, "You must be admin can create #{record.class.name}!")
    end
  end
end

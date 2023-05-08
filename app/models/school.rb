class School < ApplicationRecord

  belongs_to :created_by, class_name: "User", foreign_key: "created_by_id"
  resourcify
  has_many :users, through: :roles, class_name: 'User', source: :users
  has_many :courses

  validates_with IsCreatedByAdmin
  validates_presence_of :name, message: 'Name cant be blank.'
  validates :name, uniqueness: { case_sensitive: false, message: 'School Name already registered.'}

  scope :active, -> { where(status: ACTIVE) }

  SCHOOL_STATUS.each do |method_name, status|
    define_method "#{method_name.downcase}?" do |*args|
      self.status == status
    end
  end

  ["student", "school_admin", "admin"].each do |role|
    define_method "#{role.pluralize}" do |*args|
      User.with_role(role, self)
    end
  end

  def toogle_status
    self.status = self.active? ? DEACTIVATED : ACTIVE
  end
end

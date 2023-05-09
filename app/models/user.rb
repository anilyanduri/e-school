class User < ApplicationRecord
  has_secure_password
  rolify

  has_many :schools, :through => :roles, :source => :resource, :source_type => 'School'
  has_many :enrollments
  has_many :batches, through: :enrollments
  has_many :courses, through: :batches

  has_one :active_enrollment, -> { where status: :approved }, class_name: 'Enrollment', foreign_key: 'user_id'
  has_one :active_batch, through: :active_enrollment, source: :batch
  has_one :active_course, through: :active_batch, source: :course

  scope :with_batch, -> (batch) {
    where('batch_id' => batch.id)
  }


  after_create :assign_default_role
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email, message: 'Email cant be blank.'
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Please enter a valid email'}
  validates :email, uniqueness: { case_sensitive: false, message: 'Email already registered.'}

  validates_presence_of :password, message: 'Password cant be blank.'
  validates :password, length: { minimum: 6, message: 'Password should be minimum of 6 chars.'}

  validates_presence_of :first_name, message: 'First name cant be blank.'


  def assign_default_role
    # self.add_role(:student) if self.roles.blank?
  end

  def fullname
    "#{self.first_name} #{self.last_name}".strip()
  end

  ["student", "school_admin", "admin"].each do |role|
    define_method "#{role}?" do |resource|
      self.has_role? role, resource
    end
  end

end

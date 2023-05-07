class User < ApplicationRecord
  has_secure_password
  rolify
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

end

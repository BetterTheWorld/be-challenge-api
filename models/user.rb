require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt

  PRIVATE_ATTRIBUTES = %w(id password_digest)
  
  validates :email, uniqueness: true, presence: true


  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def public_attributes
  	@public_attributes ||= attributes.select do
  	  |k,_v| !PRIVATE_ATTRIBUTES.include?(k)
  	end
  end

  private

end
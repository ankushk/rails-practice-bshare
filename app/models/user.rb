class User < ActiveRecord::Base
  
  attr_accessor :password
  before_save :encrypt_password
  after_save :create_directory
  
  validates :userid, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/i, on: :create }
  validates :password, presence: true, length: {minimum: 6, maximum: 12}, on: :create
  validates_confirmation_of :password
  validates_presence_of :password_confirmation, :on => :create

  
  def self.authenticate(userid, password)
    user = find_by_userid(userid)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def create_directory
    dir = File.dirname("#{Rails.root}/private/#{userid}/hello")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end

end


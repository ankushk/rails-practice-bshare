class User < ActiveRecord::Base
  
  attr_accessor :password
  before_save :encrypt_password
  after_save :create_directory
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :userid
  validates_uniqueness_of :userid
  validates_format_of :userid, :with => /[\w\d]+/, :on => :create
  
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
    dir = File.dirname("#{Rails.root}/public/share/#{userid}/hello")
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
  end

end


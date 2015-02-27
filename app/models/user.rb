class User < ActiveRecord::Base
  has_many :identities

  # Public: Creates or finds a user from oauth information
  #
  # auth_hash  - Hash with information from omniauth
  #
  # Examples
  #
  #   User.find_or_create_from_oauth(auth_hash)
  #   # => User
  #
  # Returns a user object
  def self.find_or_create_from_oauth(auth_hash)
    identity = Identity.find_or_create_from_oauth(auth_hash)
    user = identity.user

    if user.nil?
      email = auth_hash[:info][:email]
      user = User.find_by(:email => email)

      if user.nil?
        user = User.new(:email => email,
                        :name  => auth_hash[:info][:name])
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user # return user
  end
end

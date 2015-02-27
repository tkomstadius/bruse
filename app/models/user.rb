class User < ActiveRecord::Base
  has_many :identities

  # Public: Creates or finds a user from oauth information.
  # To be used when a user signs in.
  #
  # auth_hash  - Hash with information from omniauth
  # signed_in_user - if a user is currently signed in it will be passed
  #
  # Examples
  #
  #   User.find_or_create_from_oauth(auth_hash, current_user)
  #   # => User
  #
  # Returns a user object
  def self.find_or_create_from_oauth(auth_hash, signed_in_user)
    identity = Identity.find_or_create_from_oauth(auth_hash)
    user = signed_in_user ? signed_in_user : identity.user

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
    user.sign_in
  end

  def sign_in
    self.sign_in_count += 1
    self.last_sign_in_at = DateTime.now
    self.save!
    self.id # return user
  end
end
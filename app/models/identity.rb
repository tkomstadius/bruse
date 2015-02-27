class Identity < ActiveRecord::Base
  belongs_to :user

  # Public: Creates or finds an identity from oauth information
  #
  # auth_hash  - Hash with information from omniauth
  #
  # Examples
  #
  #   Identity.find_or_create_from_oauth(auth_hash)
  #   # => Identity
  #
  # Returns an identity object
  def self.find_or_create_from_oauth(auth_hash)
    identity = self.find_by(:uid => auth_hash[:info][:uid], :service => auth_hash[:provider])
    if !identity
      identity = Identity.new(:uid     => auth_hash[:info][:uid],
                              :token   => auth_hash[:credentials][:token],
                              :service => auth_hash[:provider])
    else
      identity.token = auth_hash[:credentials][:token]
    end
    identity.save!
    identity # return identity
  end

end

class Identity < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :uid, :on => :create
  validates_presence_of [:uid, :token, :service, :name], :on => :create

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

  # Apparantly :uid => auth_hash[:info][:uid] doesn't work for drive, so I changed it to
  # :uid => auth_hash[:uid]
  def self.find_or_create_from_oauth(auth_hash)
    identity = self.find_by(:uid => auth_hash[:info][:uid], :service => auth_hash[:provider])
    if !identity
      provider = (auth_hash[:provider].include? 'dropbox') ? 'Dropbox' :
        (auth_hash[:provider].include? 'google') ? 'Google Drive' : auth_hash[:provider]
      identity = Identity.new(:uid => auth_hash[:uid],
                              :token   => auth_hash[:credentials][:token],
                              :service => auth_hash[:provider],
                              :name    => "#{provider} - #{auth_hash[:info][:name]}")
    else
      identity.token = auth_hash[:credentials][:token]
    end
    identity.save!
    identity # return identity
  end

end

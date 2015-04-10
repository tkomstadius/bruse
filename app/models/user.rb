class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  # relations
  has_many :identities
  belongs_to :default_identity, class_name: "Identity"

  # validations
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                              message: "enter a valid email" },
                    on: :create
  validates_presence_of :name, :on => :create

  # before/after hooks
  before_destroy :delete_identities
  after_create :send_welcome_email
  after_create :append_local_identity
  after_update :append_local_identity

  # methods

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
  def self.find_or_create_from_oauth(auth_hash, signed_in_user = nil)
    if auth_hash.nil?
      return nil
    end
    identity = Identity.find_or_create_from_oauth(auth_hash)
    user = signed_in_user ? signed_in_user : identity.user

    if user.nil?
      email = auth_hash[:info][:email]
      user = User.find_by(:email => email)

      if user.nil?
        user = User.new(:email => email,
                        :name  => auth_hash[:info][:name],
                        :password => Devise.friendly_token[0,20])
        user.own_password = false
        user.skip_confirmation!
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  protected

  def delete_identities
    self.identities.each do |id|
      id.destroy
    end
  end

  private
    # Private: Create an identity for local file handling when user is created.
    # Future: This should only happen if user has a password.
    #
    # Returns nothing
    def append_local_identity
      if own_password && !identities.exists?(service: 'local')
        local_identity = Identity.new(service: 'local',
                                      token: SecureRandom.hex(5),
                                      name: 'Bruse',
                                      uid: SecureRandom.hex(5))
        identities << local_identity
      end
    end
end

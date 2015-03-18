class BruseFile < ActiveRecord::Base
  # relations
	has_and_belongs_to_many :tags
  belongs_to :identity

  ## validations
  # make sure file only added once from each identity
  validates :foreign_ref, uniqueness: { scope: :identity,
    message: 'That file appears to be added!' }

  # Fuzzy search for :name
  fuzzily_searchable :name

  # Generates a secure and unique download hash
  def generate_download_hash
    begin
      self.download_hash = SecureRandom.hex
    end while self.class.exists?(download_hash: download_hash)
    self.save! # save to database
    self.download_hash # return
  end
end

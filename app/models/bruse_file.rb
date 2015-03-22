class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags
  belongs_to :identity

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

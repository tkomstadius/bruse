class BruseFile < ActiveRecord::Base
  # relations
	has_and_belongs_to_many :tags
  belongs_to :identity

  ## validations
  # make sure file only added once from each identity
  validates :foreign_ref, uniqueness: { scope: :identity,
    message: 'That file appears to be added!' }
  # make sure name, foreign_ref and filetype is present
  validates :name, :foreign_ref, :filetype, presence: true
  validates :name, :foreign_ref, :filetype, :identity_id, presence: true

  # Fuzzy search for :name
  fuzzily_searchable :name

  def self.find_from_search(query, current_user_id)
    results = []
    query.each do |q|
      file = self.find_by(:filetype => q)
      results.push(file) if file && file.identity.user_id == current_user_id
    end
    results.uniq #return
  end

  # Generates a secure and unique download hash
  def generate_download_hash
    begin
      self.download_hash = SecureRandom.hex
    end while self.class.exists?(download_hash: download_hash)
    self.save! # save to database
    self.download_hash # return
  end
end

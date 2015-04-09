class BruseFile < ActiveRecord::Base

	has_and_belongs_to_many :tags, dependent: :destroy

  belongs_to :identity
	attr_accessor :tagname


	validates :filetype,     presence: true

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
      q = q.downcase
      file = self.where('filetype LIKE ? OR name LIKE ?', "%#{q}%", "%#{q}")
      file.each do |f|
        results.push(f) if f.identity.user.id == current_user_id
      end
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

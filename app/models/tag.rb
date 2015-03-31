class Tag < ActiveRecord::Base
	has_and_belongs_to_many :bruse_files
  attr_accessor :file_id

  # Fuzzy search for :name
  fuzzily_searchable :name
end

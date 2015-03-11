class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags
  belongs_to :identity

  # Fuzzy search for :name
  fuzzily_searchable :name
end

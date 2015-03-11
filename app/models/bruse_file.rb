class BruseFile < ActiveRecord::Base
	has_and_belongs_to_many :tags
  # Fuzzy search for :name
  fuzzily_searchable :name
end

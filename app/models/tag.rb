class Tag < ActiveRecord::Base
	has_and_belongs_to_many :bruse_files
  # Fuzzy search for :name
  fuzzily_searchable :name

  def self.find_from_search(query)
    results = []
    query.each do |q|
      results.push(self.find_by(:name => q))
    end
    results.uniq
  end
end

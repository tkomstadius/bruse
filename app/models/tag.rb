class Tag < ActiveRecord::Base
	has_and_belongs_to_many :bruse_files
  # Fuzzy search for :name
  fuzzily_searchable :name

  def self.find_from_search(query)
    results = []
    query.each do |q|
      self.find_by(:name => q).bruse_files.each do |f|
        results.push(f)
      end
    end
    results.uniq
  end
end

class Tag < ActiveRecord::Base
	has_and_belongs_to_many :bruse_files

  # Fuzzy search for :name
  fuzzily_searchable :name, async: true

  def self.find_from_search(query, current_user_id)
    results = []
    query.each do |q|
      tag = self.find_by(:name => q)
      if tag
        tag.bruse_files.each do |f|
          results.push(f) if f.identity.user_id == current_user_id
        end
      end
    end
    results.uniq
  end

  # Public: Get the files belonging to this tag and to and to the user
  #
  # user  - the user
  #
  # Returns the files, if any
  def user_files(user)
    bruse_files.joins(:identity).where(identities: { user_id: user.id })
  end
end

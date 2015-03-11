class SearchController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  # Public: Finds files from BruseFile or Tag model.
  #
  # query  - search query
  #
  # Examples
  #
  #   find("teesst")
  #   # => { files: [{name: "test"}] }
  #
  # Returns an array of files
  def find
    query = params[:query]
    # Initiates array here since ruby is a pass by reference language
    @results = []
    @results = BruseFile.find_by_fuzzy_name(query)
    tags = Tag.find_by_fuzzy_name(query)
    tags.each do |tag|
      @results.push(tag.bruse_file) # Get the files from each tag
    end
    @results.uniq # Remove duplicates
  end
end

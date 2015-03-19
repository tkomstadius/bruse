class SearchController < ApplicationController
  before_action :authenticate_user!

  def home
  end

  # Public: Finds files from BruseFile or Tag model.
  #
  # query  - search query object divided like this:
  #          {
  #             tags: [],
  #             filetypes: [],
  #             fuzzy: []
  #          }
  #
  # Examples
  #
  #   find("teesst")
  #   # => { files: [{name: "test"}] }
  #
  # Returns an array of files
  def find
    # parse query from json to ruby object
    query = params[:query]

    # Find tags from the query
    tags = Tag.find_from_search(query[:tags])
    # Find files from filetypes
    files = BruseFile.find_from_search(query[:filetypes])
    # Find fuzzy results
    fuzz = find_fuzz_from_search(query[:fuzzy])
    # Find where the arrays mathes
    @results = tags & files & fuzz
  end

  private

  def find_fuzz_from_search(query)
    # Initiates array here since ruby is a pass by reference language
    results = []

    # Get all files that matches the query
    files = BruseFile.find_by_fuzzy_name(query)
    files.each do |file|
      # push to results if the current user owns it
      results.push(file) if file.identity.user_id == current_user.id
    end

    tags = Tag.find_by_fuzzy_name(query)
    tags.each do |tag|
      # Get the files from each tag
      tag.bruse_files.each do |file|
        results.push(file) if file.identity.user_id == current_user.id
      end
    end
    results.uniq # Remove duplicates
  end
end

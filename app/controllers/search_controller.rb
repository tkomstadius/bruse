class SearchController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :find

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
    # Find tags from the query
    tags = Tag.find_from_search(params[:tags]) if params[:tags]
    # Find files from filetypes
    files = BruseFile.find_from_search(params[:filetypes]) if params[:filetypes]
    # Find fuzzy results
    fuzz = find_fuzz_from_search(params[:fuzzy]) if params[:fuzzy]
    # combine into new array and remove nils
    data = [tags, files, fuzz].compact
    # find the first array that isn't empty. Or assign emtpy array
    @results = find_first_array(data)
    data.each {|d|
      # store the similarities in @results
      @results = @results & d if !d.empty?
    } if !@results.empty? # loop through if the results isn't empty
  end

  private

  def find_fuzz_from_search(query)
    # Initiates array here since ruby is a pass by reference language
    results = []
    query.each do |q|
      # Get all files that matches the query
      files = BruseFile.find_by_fuzzy_name(q)
      files.each do |file|
        # push to results if the current user owns it
        results.push(file) if file.identity.user_id == current_user.id
      end

      tags = Tag.find_by_fuzzy_name(q)
      tags.each do |tag|
        # Get the files from each tag
        tag.bruse_files.each do |file|
          results.push(file) if file.identity.user_id == current_user.id
        end
      end
    end
    results.uniq # Remove duplicates
  end

  def find_first_array(data)
    data.each do |d|
      return d if !d.empty?
    end
    return []
  end
end

class SearchController < ApplicationController
  # TODO: implement fuzzy search
  def find
    query = params[:query]
    # Initiates array here since ruby is a pass by reference language
    @results = []
    @results = BruseFile.where(:name => query)
    tags = Tag.where(:name => query)
    tags.each do |tag|
      @results.push(tag.bruse_file) # Get the files from each tag
    end
    @results.uniq # Remove duplicates
  end
end

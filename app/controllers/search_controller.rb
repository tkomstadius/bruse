class SearchController < ApplicationController
  # TODO: implement fuzzy search
  def find
    query = params[:query]
    @results = Tag.where(:name => query)
    @results.push(File.where(:name => query))
    @results.uniq # Remove dublicates
  end
end

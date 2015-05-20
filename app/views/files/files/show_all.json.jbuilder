json.files do
  # using cache could/should improve performance for the partials
  json.cache! @bruse_files do
    # use file partial for each file
    json.partial! 'files/files/file', collection: @bruse_files, as: :file
  end
end

# this is an alternative caching sollution
# json.files @bruse_files do |file|
#   # use file partial for each file
#   json.cache! file do
#     json.partial! 'files/files/file', file: file
#   end
# end

#json.files do
 #json.array! @results
json.files @results do |file|
  # use file partial for each file
  json.partial! 'files/files/file', file: file
end
if @errors.length
  json.error do
   json.array! @errors
  end
end
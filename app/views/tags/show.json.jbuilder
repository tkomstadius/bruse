json.tag @tag
json.files @tag.bruse_files do |file|
  # use file partial for each file
  json.partial! 'files/files/file', file: file
end

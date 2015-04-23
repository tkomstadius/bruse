json.tag @tag
json.files @tag.user_files(current_user) do |file|
  # use file partial for each file
  json.partial! 'files/files/file', file: file
end

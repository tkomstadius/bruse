json.files @results do |file|
  json.name file.name
  json.id file.id
  json.identity_id file.identity.id
end

json.files @results do |file|
  json.name file.name
  json.filetype file.filetype
  json.date file.created_at.strftime("%F %R")
  json.id file.id
  json.identity_id file.identity.id
  json.tags file.tags do |tag|
    json.name tag.name
  end
end

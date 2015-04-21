json.name file.name
json.filetype file.filetype
json.date file.created_at.strftime("%F %R")
json.id file.id
json.url file.foreign_ref if file.filetype == "bruse/url"
json.add_tags_path
json.paths do
  json.file file_path(file.identity, file)
  json.add_tags new_tag_path(file)
end
json.identity do
  json.id file.identity.id
  json.name file.identity.name
end
json.tags file.tags do |tag|
  json.name tag.name
  json.path tag_path(tag)
  json.destroy_path destroy_tag_path(file, tag)
end
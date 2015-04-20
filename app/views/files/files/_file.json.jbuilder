json.name file.name
json.filetype file.filetype
json.date file.created_at.strftime("%F %R")
json.id file.id
json.identity_id file.identity.id
json.url file.foreign_ref if file.filetype == "bruse/url"
json.path file_path(file.identity, file)
json.add_tags_path new_tag_path(file)
json.tags file.tags do |tag|
  json.name tag.name
  json.path tag_path(tag)
  json.destroy_path destroy_tag_path(file, tag)
end

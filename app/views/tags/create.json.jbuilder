json.tags @file.tags do |tag|
  json.name tag.name
  json.path tag_path(tag)
  json.destroy_path destroy_tag_path(@file, tag)
end

json.file do
  json.partial! 'files/files/file', file: @file
end
json.error @error if @error

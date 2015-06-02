if !@error
  json.file do
    json.partial! 'files/files/file', file: @file
  end
else
  json.error @error if @error
end

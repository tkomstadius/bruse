json.files do
 json.array! @results
end
if @errors.length
  json.error do
   json.array! @errors
  end
end
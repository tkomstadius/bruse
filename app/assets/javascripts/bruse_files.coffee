$ ->
  $('#bruse_file_search').typeahead
    name: "bruse_file"
    remote: "/bruse_file/autocomplete?query=%QUERY"

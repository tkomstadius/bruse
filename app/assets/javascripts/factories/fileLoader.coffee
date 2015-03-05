@bruseApp.factory 'FileLoader', ['$http', ($http) ->
  return {
    async: (path) ->
      promise = $http.get('/files/browse.json?path=' + path)
        .then((response) ->
          console.log 'Collecting files...', path
          data = response.data.file.contents
          # Loop through data response and append the file's name to each child
          # of the array. Map loops through each element in the data array, and
          # sends it into a function. The function returns a modified version of
          # the child element.
          _.map(data, (child) ->
            # split path into an array with '/' as sepparator
            names = child.path.split '/'
            # apend the file name to child
            child.name = names[names.length-1]
            return child
            )
          return data
          )
      return promise
  }
]

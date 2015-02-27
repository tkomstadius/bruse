@bruseApp.factory 'fileLoader', ['$http', ($http) ->
  return {
    async: (path) ->
      promise = $http.get('/files.json?path=' + path)
        .then((response) ->
          # console.log response
          return response.data.file.contents
          )
      return promise
  }
]

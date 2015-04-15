@bruseApp.factory 'TagHandler', ['$http', ($http) ->
  return {
    ###
    Add tags to a file
      file_id:integer
      tags: string[]

    Sends a post request with the data to the server
    ###
    put: (file_id, tags)->
      post_data =
        file_id: file_id
        tags: tags

      promise = $http.post('/tags.json', post_data)
        .then((response)->
          response.data
          )
        .catch((response)->
          alert "Couldn't add tags.."
          console.error response
          )
  }
]
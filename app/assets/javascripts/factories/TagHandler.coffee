@bruseApp.factory 'TagHandler', ['$http', ($http) ->
  return {
    ###
    Add tags to a file
      file_id: integer
      tags: string[]

    Sends a post request with the data to the server
    ###
    put: (file_id, tags) ->
      post_data =
        file_id: file_id
        tags: tags

      promise = $http.post('/tags.json', post_data)
        .then((response) ->
          response.data
          )
        .catch((response) ->
          alert "Couldn't add tags.."
          response
          )

    # collect all files belonging to tag
    collectFiles: (tag_id) ->
      promise = $http.get("/tags/#{tag_id}.json")
        .then((response) ->
          response.data
          )
        .catch((response) ->
          console.error "An error occured."
          )

    # delete a specific tag from a file's list of tags
    cut: (file_id, tag_id) ->
      promise = $http.delete("/files/#{file_id}/tag/delete/#{tag_id}.json")
        .then((response) ->
          response.data
          )
        .catch((response) ->
          console.error "An error occured.", response
          )
  }
]

@bruseApp.factory 'FileHandler', ['$http', ($http) ->
  # here, we return an object with different async methods
  return {
    #
    # Collect saved BruseFiles from this identity or all
    #
    collect: (identity) ->
      path = if identity then '/service/'+identity.id+'/files.json' else '/files.json'
      # send a get request
      promise = $http.get(path)
        .then((response) ->
          # return files
          response.data.files
          )
        .catch((response) ->
          alert "Failed to collect exsiting files!"
          console.log response
          )

    #
    # Delete file
    #
    delete: (identity, file) ->
      # post it to our backend!
      # promise gets returned
      promise = $http.delete('/service/'+identity.id+'/files/'+file.bruse_file.id+'.json')
        .then((response) ->
          # file should have been deleted, return what the server says about
          # this file
          response.data.file
          )
        .catch((response) ->
          # some error occured! notify user and log the accident.
          alert "Could not un-save file!"
          console.log response
          )

    #
    # Get files from remote service
    #
    get: (identity, path) ->
      # the promise gets returned
      promise = $http.get('/service/'+identity.id+'/files/browse.json?path=' + path)
        .then((response) ->
          console.log 'Collecting files...', path
          data = response.data.file
          # Loop through data response and append the file's name to each child
          # of the array. Map loops through each element in the data array, and
          # sends it into a function. The function returns a modified version of
          # the child element.
          _.map(data, (child) ->
            # split path into an array with '/' as sepparator
            unless child.name
              names = child.path.split '/' if child.path
              # apend the file name to child
              child.name = names[names.length-1]
            return child
            )
          return data
          )
        .catch((response) ->
          # some error occured! notify user and log the accident.
          alert "Could not load files!"
          console.log response
          )

    #
    # Save file
    #
    put: (identity, file) ->
      console.log 'Saving file...', file.path
      console.log identity
      if identity.service.toLowerCase().indexOf('dropbox') > -1
        # prepare post data from file
        post_data =
          name: file.name
          # dropbox likes the full paths! save it as foreign ref.
          foreign_ref: file.path
          filetype: file.mime_type
          # send info whether or not this is a directory to server
          is_dir: file.is_dir
          # store some useful meta data
          meta:
            size: file.bytes
            modified: file.modified

      else if identity.service.toLowerCase().indexOf('google') > -1
        post_data =
          name: file.name
          foreign_ref: file.id
          filetype: file.mimeType
          # send info whether or not this is a directory to server
          is_dir: file.is_dir
          # store some useful meta data
          meta:
            size: file.fileSize
            modified: file.modifiedDate
      # post it to our backend!
      # promise gets returned
      promise = $http.post('/service/'+identity.id+'/files.json', post_data)
        # wait for server to be done
        .then((response) ->
          # return bruse file data
          response.data.files
          )
        .catch((response) ->
          # some error occured! notify user and log the accident.
          alert "Could not save file!"
          console.log response
          )

    #
    # Download file
    #
    download: (identity, file_id) ->
      promise = $http.get('/service/'+identity.id+'/files/download/'+file_id+'.json')
        .then((response) ->
          response.data
          )
        .catch((response) ->
          console.error response
          )
  }
]

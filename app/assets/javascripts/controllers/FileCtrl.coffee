@bruseApp.controller 'FileCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.loading = true

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load root files
  FileHandler.async($scope.identity.id, '/').then((data) ->
    $scope.files = data
    $scope.loading = false
    )

  $scope.expand = (file) ->
    # set this folder as expanded
    file.expand = !file.expand

    # if we haven't allready, load file info from dropbox
    unless file.contents and file.contents.length > 0
      $scope.loading = true
      FileHandler.async($scope.identity.id, file.path).then((data) ->
        file.contents = data
        $scope.loading = false
        )

  $scope.add = (file) ->
    # make sure we are not adding a file
    unless file.is_dir
      # prepare post data
      post_data =
        name: file.path
        foreign_ref: file.rev
        type: file.mime_type
        meta:
          size: file.bytes
          modified: file.modified

      # send file information to backend
      $http.post('/service/'+$scope.identity.id+'/files.json', post_data)
        .success((data) ->
          # file saved
          file.bruse_file = data.file
          )
        .error((data, status, headers, config) ->
          # file error
          alert "Could not add " + file.name + "! Please try again soon."
          console.log "ERROR " + status
          console.log data, headers, config
          )

  $scope.remove = (file) ->
    # send delete request
    $http.delete('/service/'+$scope.identity.id+'/files/'+file.bruse_file.id+'.json')
      .success((data) ->
        # file deleted
        file.bruse_file = data.file
        )
      .error((data, status, headers, config) ->
        # file error
        alert "Could not delete " + file.name + "! Please try again soon."
        console.log "ERROR " + status
        console.log data, headers, config
        )
]

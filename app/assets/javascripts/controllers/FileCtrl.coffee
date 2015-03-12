@bruseApp.controller 'FileCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.bruse_files = []
  $scope.loading = true

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load root files on page load
  FileHandler.get($scope.identity.id, '/').then((data) ->
    $scope.files = data

    # when we have loaded remote folder, load BruseFiles
    FileHandler.collect($scope.identity.id).then((data) ->
      $scope.bruse_files = data
      $scope.loading = false
      )
    )

  $scope.expand = (file) ->
    # set this folder as expanded
    file.expand = !file.expand

    # if we haven't allready, load file info from dropbox
    unless file.contents and file.contents.length > 0
      file.loading = true
      FileHandler.get($scope.identity.id, file.path).then((data) ->
        file.contents = data
        file.loading = false
        )

  $scope.add = (file) ->
    file.loading = true
    FileHandler.put($scope.identity.id, file).then((data) ->
      file.bruse_file = data
      file.loading = false
      )

  $scope.remove = (file) ->
    # send delete request
    file.loading = true
    if file.bruse_file
      FileHandler.delete($scope.identity.id, file).then((data) ->
        file.bruse_file = data
        file.loading = false
        )
]

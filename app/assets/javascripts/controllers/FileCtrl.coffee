@bruseApp.controller 'FileCtrl', ['fileLoader', '$scope', '$http', (fileLoader, $scope, $http) ->
  $scope.files = []
  $scope.message = "Loading files, please wait..."
  $scope.loading = true

  # load root files
  fileLoader.async('/').then((data) ->
    $scope.message = ""
    $scope.files = data
    $scope.loading = false
    )


  $scope.expand = (file) ->
    # set this folder as expanded
    file.expand = !file.expand

    # if we haven't allready, load file info from dropbox
    unless file.contents and file.contents.length > 0
      $scope.loading = true
      fileLoader.async(file.path).then((data) ->
        file.contents = data
        $scope.loading = false
        )
]

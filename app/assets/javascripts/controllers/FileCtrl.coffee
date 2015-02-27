@bruseApp.controller 'FileCtrl', ['fileLoader', '$scope', '$http', (fileLoader, $scope, $http) ->
  $scope.files = []
  $scope.message = "Loading files, please wait..."

  # load root files
  fileLoader.async('/').then((data) ->
    $scope.message = ""
    $scope.files = data
    )

  $scope.expand = (file) ->
    file.expand = !file.expand
    fileLoader.async(file.path).then((data) ->
      file.contents = data
      )
]

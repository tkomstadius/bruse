@bruseApp.controller 'FileCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.bruse_files = []
  $scope.loading = true

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load existing BruseFiles on page load
  FileHandler.collect($scope.identity.id).then((data) ->
    $scope.bruse_files = data

    # when we have loaded BruseFiles, load root remote files
    FileHandler.get($scope.identity.id, '/').then((data) ->
      $scope.files = data
      _.map $scope.files, findFile
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

  findFile = (remote_file) ->
    console.log remote_file
    # find the first corresponding brusefile. note this -------------------vvv
    bruse_file = _.where($scope.bruse_files, foreign_ref: remote_file.path)[0]
    console.log bruse_file
    # set remote_file's bruse_file property
    remote_file.bruse_file = bruse_file
    # return remote_file
    remote_file
]

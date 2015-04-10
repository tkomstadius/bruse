@bruseApp.controller 'FileCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.bruse_files = []
  $scope.loading = true

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load existing BruseFiles on page load
  FileHandler.collect($scope.identity).then((data) ->
    $scope.bruse_files = data

    # when we have loaded BruseFiles, load root remote files
    FileHandler.get($scope.identity, '/').then((data) ->
      # append data to files
      $scope.files = data
      # append BruseFile info to our file list
      _.map $scope.files, (remote_file) ->
        findFile $scope.bruse_files, remote_file
      $scope.loading = false
      )
    )

  ###*
   * expand folder file and append its content to file.content
   * @param  {obj} file   the file
  ###
  $scope.expand = (file) ->
    # set this folder as expanded
    file.expand = !file.expand

    # if we haven't already, load file info from dropbox
    unless file.contents and file.contents.length > 0
      file.loading = true
      FileHandler.get($scope.identity, file.path).then((data) ->
        file.contents = data
        # find all the already added files!
        _.map data, (remote_file) ->
          findFile $scope.bruse_files, remote_file
        file.loading = false
        )
    # return nothing
    return

  ###*
   * save file as bruse_file and append bruse_file to the file
   * @param {obj} file  the file
  ###
  $scope.add = (file) ->
    file.loading = true
    
    FileHandler.put($scope.identity, file).then((data) ->
      # add file to list of existing files
      $scope.bruse_files = $scope.bruse_files.concat(data)
      # append bruse_file to this remote file
      findFile $scope.bruse_files, file
      # if current file is a directory, do something ugly to make the plus sign turn into a minus sign
      file.bruse_file = true if file.is_dir
      file.loading = false
      )

  $scope.remove = (file) ->
    # send delete request
    file.loading = true
    if file.bruse_file
      if file.is_dir
        # use delete_folder method!
        FileHandler.delete_folder($scope.identity, file).then((data) ->
          file.bruse_file = data
          console.log 'path: ', file.path
          file.loading = false
          )
      else
        FileHandler.delete($scope.identity, file).then((data) ->
          file.bruse_file = data
          file.loading = false
          )


  ###*
  # Callback for _.map functions. Search through list_of_files, looking for
  # remote_file. When found, append the found list_of_files entry's bruse_file
  # parameter to remote_file.
  ###
  findFile = (list_of_files, remote_file) ->
    # find the first corresponding brusefile. note this --------------vvv
    bruse_file = _.where(list_of_files, foreign_ref: remote_file.path)[0]
    # set remote_file's bruse_file property
    remote_file.bruse_file = bruse_file
    # return remote_file
    remote_file
]

@bruseApp.controller 'FileCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.bruse_files = []
  $scope.new_files = []
  $scope.loading = true

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load existing BruseFiles on page load
  FileHandler.collect($scope.identity.id).then((data) ->
    $scope.bruse_files = data

    # when we have loaded BruseFiles, load root remote files
    FileHandler.get($scope.identity.id, '/').then((data) ->
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

    # if we haven't allready, load file info from dropbox
    unless file.contents and file.contents.length > 0
      file.loading = true
      FileHandler.get($scope.identity.id, file.path).then((data) ->
        file.contents = data
        # find all the allready added files!
        _.map data, (remote_file) ->
          findFile $scope.bruse_files, remote_file
        file.loading = false
        )
    # return nothing
    return

  ###*
   * save file to temp array
   * @param {obj} file  the file to add
  ###
  $scope.add = (file) ->
    if file.is_dir
      console.log "Can't add folders yet!"
    else
      file.added = true
      $scope.new_files.push(file)

  ###*
   * remove temp added file
   * @param  {obj} file   the file to remove
  ###
  $scope.remove = (file) ->
    if file.is_dir
      console.log "Can't remove folders yet!"
    else
      file.added = false
      # remove file from new_files

  ###*
   * save all files to db
  ###
  $scope.save = ->
    _.each $scope.new_files, (file, index) ->
      FileHandler.put($scope.identity.id, file).then((data) ->
        # add file to list of existing files
        $scope.bruse_files = $scope.bruse_files.concat(data)
        # append bruse_file to this remote file
        findFile $scope.bruse_files, file
        # remove file from lists of files to add
        if index is $scope.new_files.length
          # do something better here
          console.log "done!"
        )
      $scope.new_files = _.without $scope.new_files, file


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

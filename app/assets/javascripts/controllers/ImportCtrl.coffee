@bruseApp.controller 'ImportCtrl', ['FileHandler', '$scope', '$rootScope', '$location', 'MimeDictionary', (FileHandler, $scope, $rootScope, $location, MimeDictionary) ->
  $scope.files = []
  $scope.bruse_files = []
  $scope.new_files = []

  NProgress.start()

  # get identity information from add view
  $scope.identity = IDENTITY_PARAMS

  # load existing BruseFiles on page load
  FileHandler.collect(identity: $scope.identity).then((data) ->
    $scope.bruse_files = data
    NProgress.set(.5)

    # when we have loaded BruseFiles, load root remote files
    FileHandler.get($scope.identity, '/').then((data) ->
      # append data to files
      $scope.files = data
      # append BruseFile info to our file list
      _.map $scope.files, (remote_file) ->
        findFile $scope.bruse_files, remote_file

      NProgress.done()
      )
    )

  ###*
   * expand folder file and append its content to file.content
   * @param  {obj} file   the file
  ###
  $scope.expand = (file) ->
    # set this folder as expanded
    file.expand = !file.expand

    # if we haven't already, load file info from service
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
   * save file to temp array
   * @param {obj} file  the file to add
  ###
  $scope.add = (file) ->
    if file.is_dir and !file.contents
      file.loading = true
      FileHandler.get($scope.identity, file.path).then((data)->
        file.contents = data
        _.map data, (remote_file) ->
          findFile $scope.bruse_files, remote_file
        addFiles(file)
        file.loading = false
        )
    else if file.is_dir
      addFiles(file)
    else if !file.added
      file.added = true
      $scope.new_files.push(file)

  ###
    * Helper function for $scope.add
    * Used to add files from folders
  ###
  addFiles = (file)->
    file.loading = true
    file.contents.forEach((f) ->
      $scope.add(f)
      file.loading = false
      return
      )
    file.added = true

  ###*
   * remove temp added file
   * @param  {obj} file   the file to remove
  ###
  $scope.remove = (file) ->
    if file.is_dir and file.contents
      file.contents.forEach((f)->
        $scope.remove(f)
        )
      file.added = false
    else
      file.added = false
      for i in [0..$scope.new_files.length]
        if $scope.new_files[i] == file
          $scope.new_files.splice(i, 1)
          break

  ###*
   * save all files to db
  ###
  $scope.save = ->
    NProgress.start()
    $rootScope.new_files = $scope.new_files
    _.each $scope.new_files, (file, index) ->
      FileHandler.put($scope.identity, file).then((data) ->
        # add file to list of existing files
        $scope.bruse_files = $scope.bruse_files.concat(data)
        # append bruse_file to this remote file
        findFile $scope.bruse_files, file
        # remove file from lists of files to add
        if index is $scope.new_files.length
          # do something better here
          NProgress.done()
          $location.path('/service/'+$scope.identity.id+'/files/add/tag')
          console.log "done!"
        )
      $scope.new_files = _.without $scope.new_files, file

  # mime dictionary helpers
  $scope.prettyType = (mimetype) ->
    return MimeDictionary.prettyType(mimetype)
  $scope.iconName = (mimetype) ->
    return MimeDictionary.iconName(mimetype)

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

# This provides the bFileList directive with some power
@bruseApp.controller 'FileListCtrl', ['$scope', '$filter', 'FileHandler', 'TagHandler', 'FilePreparer', 'MimeDictionary', 'FilePreviewer', 'defaults', '$parse',($scope, $filter, FileHandler, TagHandler, FilePreparer, MimeDictionary, FilePreviewer, defaults, $parse) ->
  # since we use 'this' in some function below, we need to make sure they are
  # use the the controller as the 'this', and not the function
  self = this
  # setup some vars
  $scope.files = []
  # default view filtering
  $scope.view_list = true
  $scope.showIdentities = []
  $scope.order_by = 'date'
  $scope.reverse = true
  # default file collecting settings
  $scope.offset = 0
  $scope.limit = 20
  $scope.absoluteLimit = 40
  $scope.moreAvailable = false

  # this function gets called from the directive
  this.init = (element, attrs) ->
    self.$element = element
    # if files are provided through the directive attribute, use those files...
    if attrs.files
      tempFiles = $parse(attrs.files)($scope.files)
      tempFiles.map(FilePreparer)
      $scope.files = tempFiles
    else
      # ... or use the path provided to the directive...
      # ... otherwise collect them from server
      _recursiveCollect(attrs)

  # "private" function to be used when downloading files
  _recursiveCollect = (attrs) ->
    # show loading indicator
    NProgress.start()
    NProgress.inc()
    # collect files using file handler, and send ordering params along
    FileHandler.collect(
      path: if attrs then attrs.path else null
      limit: $scope.limit
      offset: $scope.offset
      order_by: $scope.order_by).then((data) ->
      # tick loading indicator!
      NProgress.set($scope.offset/$scope.absoluteLimit)
      # check if we should load more?
      if data.length >= $scope.limit && $scope.offset < $scope.absoluteLimit
        $scope.offset += $scope.limit
        $scope.moreAvailable = true
        _recursiveCollect(attrs)
      else
        # hide loading indicator
        NProgress.done()
        # if we get less than we asked for, there's no more files available
        $scope.moreAvailable = false if data.lenght < $scope.limit

      # iterate over all the collected files
      _.each(data, (file) ->
        # append every file to the list of files
        $scope.files.push FilePreparer(file)
        )
      )

  # Gets called when a file is clicked
  $scope.download = (identity_id, file) ->
    unless file.filetype == "bruse/url"
      FileHandler.download(identity_id, file.id).then((data) ->
        # open the returned url in a new tab
        win = window.open('/'+data.url, '_self')
        )


  $scope.previewFile = (file) ->
    # call file previewer
    FilePreviewer(file, { scope: $scope })

  $scope.saveTags = (file) ->
    tagsToSave = file.unsavedTags.getTagValues()
    TagHandler.put(file.id, tagsToSave).then((data) ->
      file.tags = data.tags
      file.editTags = false
      )

  ###*
   * Remove tag with id tag_id from file
  ###
  $scope.cutTag = (file, tag_id) ->
    TagHandler.cut(file.id, tag_id).then((data) ->
      file.tags = data.tags
      )

  $scope.loadMore = ->
    $scope.absoluteLimit += $scope.limit
    _recursiveCollect()

  $scope.identities = ->
    return [] unless $scope.hasFiles()
    uniqueIdentities = _.uniq($scope.files, 'identity.name')
    _.pluck(uniqueIdentities, 'identity')

  # change mime to only filetype
  $scope.getFiletype = (mimetype) ->
    MimeDictionary.prettyType(mimetype)

  $scope.hasFiles = ->
    Array.isArray($scope.files) && $scope.files.length > 0
]

# This provides the bFileList directive with some power
@bruseApp.controller 'FileListCtrl', ['$scope', '$filter', 'FileHandler', 'TagHandler', 'JSTagsCollection', 'MimeDictionary', 'FilePreviewer', ($scope, $filter, FileHandler, TagHandler, JSTagsCollection, MimeDictionary, FilePreviewer) ->
  # since we use 'this' in some function below, we need to make sure they are
  # use the the controller as the 'this', and not the function
  self = this
  # setup some vars
  $scope.files = []
  $scope.view_list = true
  $scope.showIdentities = []

  # this function gets called from the directive
  this.init = (element, attrs) ->
    self.$element = element
    if attrs.files
      # if file is provided through the directive attributes, use those...
      $scope.files = attrs.files
    else
      # ... or use the path provided to the directive...
      # ... otherwise collect them from server
      offset = 0
      limit = 20
      absoluteLimit = 100

      recursiveCollect = ->
        # show loading indicator
        NProgress.start()
        FileHandler.collect(path: attrs.path, limit: limit, offset: offset).then((data) ->
          # tick loading indicator!
          NProgress.inc()
          # check if we should load more?
          if data.length >= limit && offset < absoluteLimit
            offset += limit
            recursiveCollect()
          else
            # hide loading indicator
            NProgress.done()

          # iterate over all the collected files
          data.map((file) ->
            # extract tag names
            onlyTags = _.pluck(file.tags, 'name')
            # append jsTag stuff to every file
            file.unsavedTags = new JSTagsCollection(onlyTags)
            # TODO: use some sort of default for bruse jsTags here?
            file.jsTagOptions =
              breakCodes: [32, 13, 9, 44] #space, enter, tab, comma
              tags: file.unsavedTags
              texts:
                inputPlaceHolder: "Tag"
                removeSymbol: String.fromCharCode(215)
            # append every file to the list of files
            $scope.files.push file
            )
          )
      recursiveCollect()

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

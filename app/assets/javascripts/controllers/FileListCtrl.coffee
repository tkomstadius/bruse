# This provides the bFileList directive with some power
@bruseApp.controller 'FileListCtrl', ['$scope', 'FileHandler', ($scope, FileHandler) ->
  # since we use 'this' in some function below, we need to make sure they are
  # use the the controller as the 'this', and not the function
  self = this
  # setup some vars
  $scope.files = []
  $scope.view_list = true

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
        FileHandler.collect(path: attrs.path, limit: limit, offset: offset).then((data) ->
          # check if we should load more?
          if data.length >= limit && offset < absoluteLimit
            offset += limit
            recursiveCollect()
          # append every file to the list of files
          data.map((file) ->
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

  # change mime to only filetype
  $scope.getFiletype = (mimetype) ->
    mimetype.split("/")[1]

  $scope.hasFiles = ->
    Array.isArray($scope.files) && $scope.files.length > 0
]

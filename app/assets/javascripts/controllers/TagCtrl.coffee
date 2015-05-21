@bruseApp.controller 'TagCtrl', ['$scope', '$rootScope', '$location', '$routeParams', 'TagHandler', 'JSTagsCollection', ($scope, $rootScope, $location, $routeParams, TagHandler, JSTagsCollection) ->
  # Redirect if no files are present
  if !$rootScope.new_files || !$rootScope.new_files.length
    $location.path('/service/'+$routeParams.identity_id+'/files/add')

  $scope.files = $rootScope.new_files

  # Some jsTag options
  $scope.tags = new JSTagsCollection();
  $scope.jsTagOptions =
    texts:
      inputPlaceHolder: "Tags..."
      removeSymbol: String.fromCharCode(215)
    tags: $scope.tags
    breakCodes: [32, 13, 9, 44] #space, enter, tab, comma

  # Initiate the tags variable for each file
  $scope.files.forEach((file) ->
    file.tags = new JSTagsCollection();
    file.jsTagOptions = angular.copy($scope.jsTagOptions)
    return
    )

  putTags = (file_id, new_tags, i) ->
    console.log "Adding tags to file with index", i
    TagHandler.put(file_id, new_tags).then((data) ->
      i++
      if i != $scope.files.length
        putTags($scope.files[i].bruse_file.id, $scope.files[i].new_tags, i)
      else
        window.location.replace('/files')
      return
      )
    return

  $scope.save = ->
    tagsForAll = _.compact($scope.tags.getTagValues())
    ###
    For each file, split the input field by space into an array.
    Remove empty strings with the _.compact method.
    And lastly combine two arrays with concat.
    ###
    i = 0
    while i < $scope.files.length
      tagsForFile = _.compact $scope.files[i].tags.getTagValues()
      $scope.files[i].new_tags = tagsForFile.concat tagsForAll
      if $scope.files[i].new_tags.length == 0
        $scope.files.splice i, 1
      else
        i++
    putTags($scope.files[0].bruse_file.id, $scope.files[0].new_tags, 0)
]

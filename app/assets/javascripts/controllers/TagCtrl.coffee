@bruseApp.controller 'TagCtrl', ['$scope', '$rootScope', '$location', '$routeParams', 'TagHandler', ($scope, $rootScope, $location, $routeParams, TagHandler) ->
  # Redirect if no files are present
  if !$rootScope.new_files || !$rootScope.new_files.length
    $location.path('/service/'+$routeParams.identity_id+'/files/add')

  $scope.files = $rootScope.new_files
  $scope.tags = ""

  putTags = (file_id, new_tags, i) ->
    console.log "Adding tags to file with index", i
    TagHandler.put(file_id, new_tags).then((data) ->
      i++
      if i != $scope.files.length
        putTags($scope.files[i].bruse_file.id, $scope.files[i].new_tags, i)
      else
        window.location.replace('/bruse_files')
      return
      )
    return

  $scope.save = ->
    tagsForAll = _.compact $scope.tags.split ' '
    ###
    For each file, split the input field by space into an array.
    Remove empty strings with the _.compact method.
    And lastly combine two arrays with concat.
    ###
    i = 0
    while i < $scope.files.length
      $scope.files[i].tags = "" if !$scope.files[i].tags
      tagsForFile = _.compact $scope.files[i].tags.split ' '
      $scope.files[i].new_tags = tagsForFile.concat tagsForAll
      if $scope.files[i].new_tags.length == 0
        $scope.files.splice i, 1
      else
        i++
    putTags($scope.files[0].bruse_file.id, $scope.files[0].new_tags, 0)
]


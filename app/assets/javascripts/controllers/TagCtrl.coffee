@bruseApp.controller 'TagCtrl', ['$scope', '$rootScope', '$location', '$routeParams', 'TagHandler', ($scope, $rootScope, $location, $routeParams, TagHandler) ->
  if !$rootScope.new_files || !$rootScope.new_files.length
    $location.path('/service/'+$routeParams.identity_id+'/files/add')

  $scope.files = $rootScope.new_files
  $scope.tags = ""

  $scope.save = ()->
    success = true
    tagsForAll = _.compact $scope.tags.split ' '
    ###
    For each file, split the input field by space into an array.
    Remove empty strings with the _.compact method.
    And lastly combine two arrays with concat.
    ###
    $scope.files.forEach((file)->
      file.tags = "" if !file.tags
      tagsForFile = _.compact file.tags.split ' '
      file.new_tags = tagsForFile.concat tagsForAll
      if file.new_tags.length > 0
        TagHandler.put(file.bruse_file.id, file.new_tags).then((data)->
          success = data
          )
      )
    window.location.replace('/bruse_files') if success
]

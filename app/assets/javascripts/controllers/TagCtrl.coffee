@bruseApp.controller 'TagCtrl', ['$scope', '$rootScope', 'TagHandler', ($scope, $rootScope, TagHandler) ->
  $scope.files = $rootScope.new_files
  $scope.tags = ""

  $scope.save = ()->
    success = true
    $scope.files.forEach((file)->
      tagsForAll = _.compact $scope.tags.split ' '
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

@bruseApp.controller 'TagCtrl', ['$scope', '$rootScope', '$routeParams', ($scope, $rootScope, $routeParams) ->
  $scope.files = $rootScope.new_files
  $scope.tags = ""
  $scope.identity = {
    id: $routeParams.identity_id
  }

  $scope.save = ()->
    _.map $scope.files, (file)->
      tagsForAll = _.compact $scope.tags.split ' '
      tagsForFile = _.compact file.tags.split ' '
      file.new_tags = tagsForFile.concat tagsForAll
      console.log file.new_tags
]

@bruseApp.controller 'DragDropCtrl', ['$scope', '$http', '$rootScope', '$location', ($scope, $http, $rootScope, $location) ->
  $scope.droppedFiles = []
  $scope.dataObjects = {}
  $scope.imageFiles = []
  $scope.isDropped = false
  $scope.isSaved = false
  $scope.message = ''
  $scope.notSaved = ''

  $scope.saveOpt = (location) ->
    if location == ''
      $scope.isDropped = false
      $scope.droppedFiles = []
      $scope.notSaved = ''
    else
      $scope.isDropped = false
      $scope.dataObjects.objects = $scope.droppedFiles
      $scope.dataObjects.location = location

      # send object to server
      _.each $scope.droppedFiles, (file) ->
        $http.post('/upload_drop.json', {object: file, location: location}).then((response) ->
          # WHY do I also get previous saves?
          # WHY do I also get previous saves?
          # need id for file to add tags
          # $rootScope.new_files = the files that have been added
          # $location.path('/service/'+$scope.identity.id+'/files/add/tag')
          console.log response.data.files
          if response.data.error != []
            $scope.isSaved = true
            $scope.message = "Saved to " + location
          else
            $scope.isSaved = false
            $scope.message = "Something went wrong"
          )
        .catch((response) ->
          console.error "Couldn't save.."
          return
          )
] 


@bruseApp.controller 'DragDropCtrl', ['$scope', '$http', ($scope, $http) ->
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
      $scope.dataObjects.location = location.id

      # send object to server
      _.each $scope.droppedFiles, (file) ->
        $http.post('/upload.json', {bruse_file: file, identity_id: location.id}).then((response) ->
          # WHY do I also get previous saves?
          if response.data.error != []
            $scope.isSaved = true
            $scope.message = "Saved " + response.data.file.name + " to " + response.data.file.identity.name
          else
            $scope.isSaved = false
            $scope.message = response.data.error[0]
          )
        .catch((response) ->
          console.error "Couldn't save.."
          return
          )
]

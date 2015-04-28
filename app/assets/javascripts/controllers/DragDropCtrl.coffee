# TODO: create modal for save option?
@bruseApp.controller 'DragDropCtrl', ['$scope', '$http', ($scope, $http) ->
    $scope.droppedFiles = []
    $scope.dataObjects = {}
    $scope.imageFiles = []
    $scope.isDropped = false
    $scope.isSaved = false
    $scope.message = ''

    $scope.saveOpt = (location) ->
      if location == ''
        $scope.isDropped = false
        $scope.droppedFiles = []
      else
        $scope.isDropped = false
        $scope.dataObjects.objects = $scope.droppedFiles
        $scope.dataObjects.location = location

        # send object to server
        $http.post('/upload_drop.json', $scope.dataObjects).then((response) ->
          console.log $scope.imageFiles
          if response.data.error != []
            $scope.isSaved = true
            $scope.message = $scope.message + response.data.files + ", "
          else
            $scope.isSaved = false
            $scope.message = "Something went wrong"
          $scope.message = $scope.message + " saved to " + location
          )
        .catch((response) ->
          console.error "Couldn't save.."
          return
          )
]


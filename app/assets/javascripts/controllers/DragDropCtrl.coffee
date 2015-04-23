# TODO: create modal for save option?
@bruseApp.controller 'DragDropCtrl', ['$scope', '$http', ($scope, $http) ->
    $scope.fileObject = []
    $scope.dataObject = {location:''}
    $scope.imageFile = null
    $scope.isDropped = false
    $scope.isSaved = false
    $scope.file = []
    $scope.message = ''

    $scope.saveOpt = (location) ->
      $scope.isDropped = false
      $scope.dataObject.location = location

      if location != ''
        # send object to server
        $http.post('/upload_drop.json', $scope.dataObject).then((response) ->
          $scope.file = response.data.file;
          if $scope.file.id != null
            $scope.isSaved = true
            $scope.message = response.data.file.name + " was saved"
          else
            $scope.file = []
            $scope.isSaved = false
          )
        .catch((response) ->
          console.error "Couldn't save.."
          )
]


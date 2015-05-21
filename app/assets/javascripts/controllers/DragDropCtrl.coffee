@bruseApp.controller 'DragDropCtrl', ['$scope', '$http', '$rootScope', '$location', ($scope, $http, $rootScope, $location) ->
  $scope.droppedFiles = []
  $scope.dataObjects = {}
  $scope.isDropped = false
  $scope.isSaved = false
  $scope.message = ''
  $scope.notSaved = ''
  $scope.addedFile = []
  $scope.savedFiles = []
  $scope.numFiles = 0

  $scope.saveOpt = (location) ->
    if location == ''
      $scope.isDropped = false
      $scope.droppedFiles = []
      $scope.notSaved = ''
    else
      $scope.isDropped = false
      $scope.dataObjects.objects = $scope.droppedFiles
      $scope.numFiles = $scope.droppedFiles.length
      $scope.dataObjects.location = location
      $scope.addedFile = []

      # send object to server
      _.each $scope.droppedFiles, (file) ->
        $http.post('/upload_drop.json', {object: file, location: location}).then((response) ->

          if response.data.error != []
            $scope.isSaved = true
            $scope.message = "Saved to " + location
            $scope.droppedFiles = []
            $scope.addedFile.push response.data.files[0]
          else
            $scope.isSaved = false
            $scope.message = "Something went wrong"
          )
        .catch((response) ->
          console.error "Couldn't save.."
          return
          ) 

  $scope.getSavedFiles = ->
    $scope.savedFiles = $scope.addedFile
    if $scope.savedFiles.length == $scope.numFiles
      return true
    else
      return false
]   



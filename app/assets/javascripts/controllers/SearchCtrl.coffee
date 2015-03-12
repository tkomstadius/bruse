@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []

  $scope.$watch "search", () ->
    if($scope.search != "")
      $http.get('/search/'+$scope.search)
        .then((response) ->
          if response.data.files.length > 0
            $scope.files = response.data.files;
          else
            console.log "No results found"
          )
        .catch((response) ->
          console.error "Couldn't search.."
          )
    else
      $scope.files = []

  $scope.download = (identity_id, file_id) ->
    FileHandler.download(identity_id, file_id).then((data) ->
      win = window.open('/'+data.url, '_blank')
      win.focus()
      )
]

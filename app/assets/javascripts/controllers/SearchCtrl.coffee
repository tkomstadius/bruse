@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []

  # watches the search input field for changes
  $scope.$watch "search", () ->
    if($scope.search != "")
      # send a search request to the server
      $http.get('/search/'+$scope.search)
        .then((response) ->
          if response.data.files.length > 0
            # write reponse to the current scope
            $scope.files = response.data.files;
          else
            console.log "No results found"
          )
        .catch((response) ->
          console.error "Couldn't search.."
          )
    else
      $scope.files = []

  # Gets called when a file is clicked
  $scope.download = (identity_id, file_id) ->
    FileHandler.download(identity_id, file_id).then((data) ->
      # open the returned url in a new tab
      win = window.open('/'+data.url, '_blank')
      win.focus()
      )
]

@bruseApp.controller 'SearchCtrl', ['$scope', '$http', ($scope, $http) ->
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
]

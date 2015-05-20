@bruseApp.controller 'HeaderCtrl', ['$scope', ($scope) ->
  $scope.toggle = (e, obj) ->
    e.preventDefault()
    $scope[obj] = !$scope[obj]
]

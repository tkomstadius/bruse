@bruseApp.controller 'CreateFromTextCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.text = ''
  $scope.loading = false

  $scope.save = ->
    # make sure text is long "enough"
    unless $scope.text.length > 3
      return

    console.log 'saving:', $scope.text.trim()
    $scope.loading = true

    $http.post('/create_file.json', text: content: $scope.text.trim())
      .success (data) ->
        $scope.text = ''
        $scope.msg = 'Created file'
        $scope.loading = false
      .error (data, status) ->
        console.log 'Could not create file. Error: ', status
        $scope.loading = false
]

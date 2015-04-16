@bruseApp.controller 'CreateFromTextCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.text = ''
  $scope.loading = false

  $scope.$watch "text", (newText, oldText) ->
    return '' unless angular.isDefined(newText) && angular.isDefined(oldText)
    # regex is afwul but useful, look here to understand what it does: http://www.regexr.com/3aqpu
    urlPattern = new RegExp('(https?|s?ftp):\/\/[\w-]*(\.[\w-]*)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?')
    # this regex matches any ws char
    spacePattern = new RegExp('\s')

    # create as url if there is an url in the field and no ws chars
    if urlPattern.test($scope.text) && !spacePattern.test(newText)
      $scope.message = "It looks to us as if you're about to save a link."
    else
      $scope.message = ""

  $scope.save = ->
    # make sure text is long "enough"
    unless $scope.text.length > 3
      return
    $scope.loading = true
    $http.post('/create_file.json', text: content: $scope.text.trim())
      .success (data) ->
        $scope.text = ''
        $scope.message = 'Created file'
        $scope.loading = false
      .error (data, status) ->
        console.log 'Could not create file. Error: ', status
        $scope.loading = false
]

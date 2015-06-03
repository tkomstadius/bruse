@bruseApp.controller 'CreateFromTextCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.text = ''
  $scope.loading = false

  $scope.$watch "text", (newText, oldText) ->
    return unless angular.isDefined(newText) && angular.isDefined(oldText)
    # regex is afwul but useful, look here to understand what it does: http://www.regexr.com/3aqpu
    urlPattern = new RegExp('(https?|s?ftp):\/\/[\w-]*(\.[\w-]*)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?')
    # this regex matches any ws char
    spacePattern = new RegExp('\\s', 'g')

    # create as url if there is an url in the field and no ws chars
    if urlPattern.test(newText) && !spacePattern.test(newText)
      $scope.url = true
    else
      $scope.url = false

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
        $scope.message = 'Could not create file. Perhaps it already exists?'
        console.log 'Could not create file. Error: ', status
        $scope.loading = false
]

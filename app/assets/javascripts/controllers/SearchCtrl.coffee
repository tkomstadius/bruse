@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.files = []
  $scope.search = ""

  # watches the search input field for changes
  $scope.$watch "search", () ->
    #console.log $scope.search;

    if $scope.search != ""
      # console.log typeof $scope.search
      temp = $scope.search.split(" ")
      #console.log temp;
      temp.forEach (element, index, array) ->
        #console.log element.charAt(0)
        #must send searchinfo all the time
        if element.charAt(0) == "#"
          tags = []
          tags.push element
        else if element.charAt(0) == "."
          types = []
          types.push element
        else
          $scope.files.push element
        
        console.log $scope.files
        console.log types
        console.log tags

        #TODO: make sure that there are something in array to measure length


      # send a search request to the server
      $http.get('/search/'+$scope.search)
        .then((response) ->
          if response.data.files.length > 0
            # write reponse to the current scope

            $scope.files = response.data.files;
          else
            console.log "No results found"
          # write reponse to the current scope
          $scope.files = response.data.files;
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
      win.focus() # TODO: make sure it is not stopped by ad-block
      )
]

@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.search = ""
  $scope.files = []

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
          docName = []
          docName.push element

          # send a search request to the server
          $http.get('/search/'+docName)
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
        console.log docName
        console.log types
        console.log tags
        console.log "----------------------------------"

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

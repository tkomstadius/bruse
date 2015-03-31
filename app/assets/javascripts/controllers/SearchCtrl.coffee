@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', (FileHandler, $scope, $http) ->
  $scope.search = ""
  $scope.files = []

  # watches the search input field for changes
  $scope.$watch "search", () ->
    #console.log $scope.search;

    if $scope.search != ""
      # console.log typeof $scope.search
      temp = $scope.search.split(" ")
      hashTags = []
      types = []
      docName = []
      #console.log temp;
      temp.forEach (element, index, array) ->
        if element.charAt(0) == "#"
          hashTags.push element
        else if element.charAt(0) == "."
          types.push element
        else
          docName.push element

      # create a search object divided by category 
      searchObject = {tags:hashTags, filetypes:types, fuzz:docName}
      
      console.log searchObject.fuzz
      console.log searchObject.filetypes
      console.log searchObject.tags
      
      # send search object to server
      $http.post('/search/api', searchObject).then((response) ->
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
      win = window.open('/'+data.url, '_self')
      )
]

@bruseApp.controller 'SearchCtrl', ['FileHandler', '$scope', '$http', '$filter', (FileHandler, $scope, $http, $filter) ->
  $scope.search = ""
  $scope.files = []
  $scope.view_list = true;
  orderBy = $filter('orderBy')

  # watches the search input field for changes
  $scope.$watch "search", (newTitle, oldTitle) ->
    if angular.isDefined(newTitle) && angular.isDefined(oldTitle)
      #console.log $scope.search;

      if $scope.search != ""
        # console.log typeof $scope.search
        temp = $scope.search.split(" ")
        hashTags = []
        types = []
        docName = []
        #console.log temp;
        temp.forEach (element, index, array) ->
          if element.charAt(0) == "#" && element.length > 1
            hashTags.push element.slice(1)
          else if element.charAt(0) == "." && element.length > 1
            types.push element.slice(1)
          else if element.length > 2
            docName.push element

        # create a search object divided by category
        searchObject = {tags:hashTags, filetypes:types, fuzzy:docName}

        # send search object to server
        $http.post('/search', searchObject).then((response) ->
          if response.data.files.length > 0
            # write reponse to the current scope
            $scope.files = response.data.files;
            $scope.order('name', false)
          else
            console.log "No results found"
            # write reponse to the current scope
            $scope.files = [];
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

  # change mime to only filetype
  $scope.getFiletype = (mimetype) ->
    mimetype.split("/")[1]

  # a function to order the files
  $scope.order = (predicate, reverse) ->
    $scope.files = orderBy($scope.files, predicate, reverse)

]

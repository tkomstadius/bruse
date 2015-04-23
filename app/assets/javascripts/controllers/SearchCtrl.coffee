@bruseApp.controller 'SearchCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.search = ""
  $scope.actualSearch = ""
  searchString = ""
  $scope.files = []

  # watches the search input field for changes
  $scope.$watch "search", (newSearch, oldSearch) ->
    if angular.isDefined(newSearch) && angular.isDefined(oldSearch)
      searchString = newSearch

      if $scope.search == ""
        $scope.actualSearch = ""
        return

      setTimeout((->
        console.log "'#{searchString}' == '#{newSearch}' : ", searchString == newSearch
        if searchString == newSearch
          $scope.actualSearch = newSearch
          temp = $scope.search.split(" ")
          hashTags = []
          types = []
          docName = []

          temp.forEach (element, index, array) ->
            if element.charAt(0) == "#" && element.length > 1
              hashTags.push element.slice(1)
            else if element.charAt(0) == "." && element.length > 1
              types.push element.slice(1)
            else if element.length > 2
              docName.push element

          # create a search object divided by category
          searchObject = {tags: hashTags, filetypes: types, fuzzy: docName}

          # send search object to server
          $http.post('/search', searchObject).then((response) ->
            $scope.files = response.data.files;
            )
          .catch((response) ->
            console.error "Couldn't search..", response
            )

        ), 1000)
]

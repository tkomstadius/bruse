@bruseApp.controller 'SearchCtrl', ['$scope', '$http', 'JSTagsCollection', 'MimeDictionary', ($scope, $http, JSTagsCollection, MimeDictionary) ->
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
        if searchString == newSearch
          console.log "Searching for '#{searchString}'"
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
          searchObject = { tags: hashTags, filetypes: types, fuzzy: docName }

          # send search object to server
          $http.post('/search', searchObject).then((response) ->
            _.each(response.data.files, (file) ->
              file.prettyFiletype = MimeDictionary.prettyType(file.filetype)
              # extract tag names
              onlyTags = _.pluck(file.tags, 'name')
              # append jsTag stuff to every file
              file.unsavedTags = new JSTagsCollection(onlyTags)
              # TODO: use some sort of default for bruse jsTags here?
              file.jsTagOptions =
                breakCodes: [32, 13, 9, 44] #space, enter, tab, comma
                tags: file.unsavedTags
                texts:
                  inputPlaceHolder: "Tags..."
                  removeSymbol: String.fromCharCode(215)
              # append every file to the list of files
              $scope.files.push file
              )
            )
          .catch((response) ->
            console.error "Couldn't search..", response
            )

        ), 500)
]

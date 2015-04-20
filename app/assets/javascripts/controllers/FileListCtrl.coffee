# This provides the bFileList directive with some power
@bruseApp.controller 'FileListCtrl', ['$scope', '$filter', 'FileHandler', ($scope, $filter, FileHandler) ->
  # since we use 'this' in some function below, we need to make sure they are
  # use the the controller as the 'this', and not the function
  self = this;
  # setup some vars
  orderBy = $filter('orderBy')
  $scope.files = []
  $scope.view_list = true


  # this function gets called from the directive
  this.init = (element, attrs) ->
    self.$element = element
    console.log 'FileListCtrl', element, attrs
    $scope.name = attrs.name
    $scope.files = attrs.files

  # Gets called when a file is clicked
  $scope.download = (identity_id, file) ->
    if file.filetype == "bruse/url"
      win = window.open(file.url, '_blank')
    else
      FileHandler.download(identity_id, file.id).then((data) ->
        # open the returned url in a new tab
        win = window.open('/'+data.url, '_self')
        )

  # change mime to only filetype
  $scope.getFiletype = (mimetype) ->
    mimetype.split("/")[1]

  $scope.hasFiles = ->
    Array.isArray($scope.files) && $scope.files.length > 0

  # a function to order the files
  $scope.order = (predicate, reverse) ->
    $scope.files = orderBy($scope.files, predicate, reverse)
]
